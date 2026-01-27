import { readdir, readFile } from "node:fs/promises";
import type { Dirent } from "node:fs";
import { join } from "node:path";

type LayersManifest = {
  layers: Array<{
    size: number;
  }>;
};

type DirectoryEntry = {
  absolutePath: string;
};

type LayersResult = {
  displayPath: string;
  outputLabel: string;
};

const MANIFESTS_ROOT_PATH = "/Users/chris/.ollama/models/manifests" as const;
const NUMBER_FORMATTER = new Intl.NumberFormat("en-US");

const collectFilePaths = async (
  directoryPath: string,
): Promise<DirectoryEntry[]> => {
  const dirents = await readdir(directoryPath, { withFileTypes: true });
  const entries = await Promise.all(
    dirents.map(async (dirent: Dirent) => {
      const absolutePath = join(directoryPath, dirent.name);
      if (dirent.isDirectory()) {
        return collectFilePaths(absolutePath);
      }
      return [{ absolutePath }];
    }),
  );
  return entries.flat();
};

const isLayersManifest = (value: unknown): value is LayersManifest => {
  if (typeof value !== "object" || value === null) {
    return false;
  }
  const maybeManifest = value as { layers?: unknown };
  if (!Array.isArray(maybeManifest.layers)) {
    return false;
  }
  return maybeManifest.layers.every((layer) => {
    if (typeof layer !== "object" || layer === null) {
      return false;
    }
    const maybeLayer = layer as { size?: unknown };
    return typeof maybeLayer.size === "number";
  });
};

const getDisplayPath = (absolutePath: string): string => {
  const pathParts = absolutePath.split("/").filter(Boolean);
  const lastParts = pathParts.slice(-3);
  return lastParts.join("/");
};

const readLayersManifest = async (
  entry: DirectoryEntry,
): Promise<LayersResult | null> => {
  const fileContent = await readFile(entry.absolutePath, "utf-8");
  let parsed: unknown;
  try {
    parsed = JSON.parse(fileContent) as unknown;
  } catch {
    return null;
  }
  if (!isLayersManifest(parsed)) {
    if (typeof parsed === "object" && parsed !== null) {
      return {
        displayPath: getDisplayPath(entry.absolutePath),
        outputLabel: "(cloud)",
      };
    }
    return null;
  }
  const totalSize = parsed.layers.reduce(
    (sum, layer) => sum + layer.size,
    0,
  );
  return {
    displayPath: getDisplayPath(entry.absolutePath),
    outputLabel: NUMBER_FORMATTER.format(totalSize),
  };
};

const main = async (): Promise<void> => {
  const entries = await collectFilePaths(MANIFESTS_ROOT_PATH);
  const results = await Promise.all(entries.map(readLayersManifest));
  results
    .filter((result): result is LayersResult => result !== null)
    .forEach((result) => {
      console.log(`${result.displayPath} ${result.outputLabel}`);
    });
};

await main();

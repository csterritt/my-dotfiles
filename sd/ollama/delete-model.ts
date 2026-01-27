import { readdir, readFile, unlink, rmdir } from "node:fs/promises";
import type { Dirent } from "node:fs";
import { basename, dirname, join } from "node:path";

interface LayersManifest {
  readonly layers?: Array<{
    readonly digest?: string;
  }>;
  readonly config?: {
    readonly digest?: string;
  };
}

interface DirectoryEntry {
  readonly absolutePath: string;
}

interface ManifestSelection {
  readonly displayPath: string;
  readonly absolutePath: string;
}

const MANIFESTS_ROOT_PATH = "/Users/chris/.ollama/models/manifests" as const;
const BLOBS_ROOT_PATH = "/Users/chris/.ollama/models/blobs" as const;
const DIGEST_PREFIX = "sha256:" as const;
const ARGUMENT_DRY_RUN_FLAG = "-d" as const;

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

const getDisplayPath = (absolutePath: string): string => {
  const pathParts = absolutePath.split("/").filter(Boolean);
  const lastParts = pathParts.slice(-3);
  return lastParts.join("/");
};

const parseArguments = (
  argv: string[],
): { isDryRun: boolean; targetName: string } => {
  const isDryRun = argv.includes(ARGUMENT_DRY_RUN_FLAG);
  const nonFlagArgs = argv.filter((arg) => arg !== ARGUMENT_DRY_RUN_FLAG);
  const targetName = nonFlagArgs[0] ?? "";
  return { isDryRun, targetName };
};

const findManifestByDisplayName = async (
  targetName: string,
): Promise<ManifestSelection | null> => {
  const entries = await collectFilePaths(MANIFESTS_ROOT_PATH);
  const match = entries.find((entry) => {
    const displayPath = getDisplayPath(entry.absolutePath);
    return displayPath === targetName;
  });
  if (!match) {
    return null;
  }
  return {
    displayPath: getDisplayPath(match.absolutePath),
    absolutePath: match.absolutePath,
  };
};

const readManifest = async (absolutePath: string): Promise<LayersManifest> => {
  const fileContent = await readFile(absolutePath, "utf-8");
  const parsed = JSON.parse(fileContent) as unknown;
  if (typeof parsed !== "object" || parsed === null) {
    throw new Error("Manifest does not contain a JSON object.");
  }
  const maybeManifest = parsed as { layers?: unknown; config?: unknown };
  const layers = Array.isArray(maybeManifest.layers)
    ? (maybeManifest.layers as Array<{ digest?: string }>)
    : undefined;
  const config =
    typeof maybeManifest.config === "object" && maybeManifest.config !== null
      ? (maybeManifest.config as { digest?: string })
      : undefined;
  return { layers, config };
};

const collectLayerDigests = (manifest: LayersManifest): Set<string> => {
  const digests = new Set<string>();
  (manifest.layers ?? []).forEach((layer) => {
    if (typeof layer.digest === "string" && layer.digest.startsWith(DIGEST_PREFIX)) {
      digests.add(layer.digest.replace(":", "-"));
    }
  });
  if (
    typeof manifest.config?.digest === "string" &&
    manifest.config.digest.startsWith(DIGEST_PREFIX)
  ) {
    digests.add(manifest.config.digest.replace(":", "-"));
  }
  return digests;
};

const findMatchingBlobs = async (
  digests: Set<string>,
): Promise<string[]> => {
  const blobEntries = await collectFilePaths(BLOBS_ROOT_PATH);
  return blobEntries
    .map((entry) => entry.absolutePath)
    .filter((absolutePath) => digests.has(basename(absolutePath)));
};

const processBlobs = async (
  blobPaths: string[],
  isDryRun: boolean,
): Promise<void> => {
  await Promise.all(
    blobPaths.map(async (absolutePath) => {
      if (isDryRun) {
        console.log(absolutePath);
        return;
      }
      await unlink(absolutePath);
    }),
  );
};

const deleteFileOrPrint = async (
  absolutePath: string,
  isDryRun: boolean,
): Promise<void> => {
  if (isDryRun) {
    console.log(absolutePath);
    return;
  }
  await unlink(absolutePath);
};

const removeDirectoryIfEmpty = async (
  directoryPath: string,
  isDryRun: boolean,
): Promise<boolean> => {
  const entries = await readdir(directoryPath);
  if (entries.length > 0) {
    return false;
  }
  if (isDryRun) {
    console.log(directoryPath);
    return true;
  }
  await rmdir(directoryPath);
  return true;
};

const main = async (): Promise<void> => {
  const { isDryRun, targetName } = parseArguments(process.argv.slice(2));
  if (!targetName) {
    console.error(
      "Usage: sd ollama remove [-d] <manifest-display-name>",
    );
    process.exit(1);
  }
  const manifestSelection = await findManifestByDisplayName(targetName);
  if (!manifestSelection) {
    console.error(`No manifest found for ${targetName}.`);
    process.exit(1);
    return;
  }
  const layersManifest = await readManifest(manifestSelection.absolutePath);
  const digests = collectLayerDigests(layersManifest);
  if (digests.size === 0) {
    console.log(`No layer digests found for ${manifestSelection.displayPath}.`);
    return;
  }
  const blobPaths = await findMatchingBlobs(digests);
  await processBlobs(blobPaths, isDryRun);
  await deleteFileOrPrint(manifestSelection.absolutePath, isDryRun);
  const parentDirectory = dirname(manifestSelection.absolutePath);
  const grandParentDirectory = dirname(parentDirectory);
  const wasParentRemoved = await removeDirectoryIfEmpty(
    parentDirectory,
    isDryRun,
  );
  if (wasParentRemoved) {
    await removeDirectoryIfEmpty(grandParentDirectory, isDryRun);
  }
};

await main();

#!/usr/bin/env ts-node

import { readFileSync, existsSync } from 'fs'
import { exec } from 'child_process'
import { promisify } from 'util'

const execPromise = promisify(exec)

interface PackageJson {
  dependencies?: Record<string, string>
  devDependencies?: Record<string, string>
}

async function getNpmVersions(packageName: string): Promise<string[]> {
  try {
    const { stdout } = await execPromise(
      `npm view ${packageName} versions --json`
    )
    return JSON.parse(stdout)
  } catch (error) {
    console.error(`Error fetching versions for ${packageName}:`, error)
    return []
  }
}

function compareVersions(
  packageVersion: string,
  latestVersion: string
): boolean {
  // Remove ^ or ~ prefix if present
  const cleanPackageVersion = packageVersion.replace(/^[\^~]/, '')

  const packageParts = cleanPackageVersion.split('.').map(Number)
  const latestParts = latestVersion.split('.').map(Number)

  // If all numbers match exactly, versions are the same
  if (packageParts.every((part, i) => part === latestParts[i])) {
    return true
  }

  // Check if only the patch version differs (only the last number)
  if (
    packageParts.length === latestParts.length &&
    packageParts.slice(0, -1).every((part, i) => part === latestParts[i])
  ) {
    return true
  }

  return false
}

async function checkDependencies() {
  // Check if package.json exists
  if (!existsSync('./package.json')) {
    console.error('package.json not found in the current directory')
    process.exit(1)
  }

  // Read package.json
  const packageJsonContent = readFileSync('./package.json', 'utf-8')
  const packageJson: PackageJson = JSON.parse(packageJsonContent)

  const allDependencies = {
    ...(packageJson.dependencies || {}),
    ...(packageJson.devDependencies || {}),
  }

  console.log('Checking for outdated dependencies...\n')

  for (const [packageName, packageVersion] of Object.entries(allDependencies)) {
    process.stdout.write(`Checking ${packageName}... `)

    const versions = await getNpmVersions(packageName)
    if (versions.length === 0) {
      console.log('No version information found')
      continue
    }

    // Find the last version that does not have 'alpha' or 'beta' in it
    let latestNonBetaVersion = ''
    for (let i = versions.length - 1; i >= 0; i--) {
      const version = versions[i]
      if (
        !version.toLowerCase().includes('alpha') &&
        !version.toLowerCase().includes('beta')
      ) {
        latestNonBetaVersion = version
        break
      }
    }

    if (!latestNonBetaVersion) {
      console.log('No non-beta version found')
      continue
    }

    const isUpToDate = compareVersions(packageVersion, latestNonBetaVersion)

    if (isUpToDate) {
      console.log('✓ Up to date')
    } else {
      console.log(`\n⚠️  Update available for ${packageName}:`)
      console.log(`   Current: ${packageVersion}`)
      console.log(`   Latest:  ${latestNonBetaVersion}\n`)
    }
  }
}

// Run the script
checkDependencies().catch((error) => {
  console.error('Error:', error)
  process.exit(1)
})

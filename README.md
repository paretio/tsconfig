# @paretio/tsconfig

Shareable TypeScript configurations for Paretio projects.

## Create New Beta Release

Create a beta release on a feature branch for testing before merging to main. Beta releases are published to npm with the `@beta` tag.

### Commands

```sh
npm run release:beta
```

### Example

```sh
# On feature branch
git checkout -b feature/add-jsx-support
git add .
git commit -m "feat: add JSX support"

# Create beta release (automatically runs tests, tags, and pushes)
npm run release:beta

# Test the beta version
cd ../other-project
npm install @paretio/tsconfig@beta

# If changes needed, create another beta
cd ../tsconfig
git add .
git commit -m "fix: address feedback"
npm run release:beta  # Creates 0.5.0-beta.1
```

## Create New Stable Release

Create a stable release on the main branch after a PR has been merged. Stable releases are published to npm with the `@latest` tag.

### Commands

```sh
# Patch release (0.5.0 → 0.5.1)
npm run release:patch

# Minor release (0.5.0 → 0.6.0)
npm run release:minor

# Major release (0.5.0 → 1.0.0)
npm run release:major

# Promote beta to stable (0.5.0-beta.1 → 0.5.0)
npm version 0.5.0
```

### Example

```sh
# After PR merged to main
git checkout main
git pull

# Create patch release
npm run release:patch

# Or promote beta to stable
npm version 0.5.0
```

## What Happens Automatically

When you run `npm version` or `npm run release:*`, the following happens automatically:

| Step | Where          | What Happens                                                          |
|------|----------------|-----------------------------------------------------------------------|
| 1    | Local          | `npm run release:beta` runs tests, updates package.json, creates tag  |
| 2    | Local          | `postversion` hook pushes commit + tag to GitHub                      |
| 3    | GitHub         | Detects tag push matching workflow pattern                            |
| 4    | GitHub Actions | Checks out code, verifies version, runs tests                         |
| 5    | GitHub Actions | Determines correct npm dist-tag (beta/latest)                         |
| 6    | GitHub Actions | Publishes to npm with provenance                                      |
| 7    | GitHub Actions | Creates GitHub Release                                                |
| 8    | NPM            | Package available for installation                                    |

**Never manually create git tags.** Always use `npm version` commands.

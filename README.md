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

Stable releases require a pull request to main. The release is published to npm with the `@latest` tag only after the PR is merged.

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
# Start from main branch
git checkout main
git pull

# Create patch release (creates release branch automatically)
npm run release:patch

# This creates release/v0.5.1 branch and pushes it
# Now create a PR from release/v0.5.1 → main
gh pr create --title "Release v0.5.1" --body "Release version 0.5.1"

# After PR is approved and merged, the workflow automatically:
# - Publishes to npm
# - Creates git tag
# - Creates GitHub release
```

## What Happens Automatically

When you run `npm run release:*`, the following happens:

| Step | Where          | What Happens                                                          |
|------|----------------|-----------------------------------------------------------------------|
| 1    | Local          | Checks for uncommitted changes (blocks if any)                        |
| 2    | Local          | Runs tests via `preversion` hook                                      |
| 3    | Local          | Updates package.json, creates commit on main                          |
| 4    | Local          | Creates `release/v*` branch with the version commit                   |
| 5    | Local          | Deletes local tag (will be created on main after merge)              |
| 6    | Local          | Pushes release branch to GitHub                                       |
| 7    | You            | Create PR from release branch → main                                  |
| 8    | You            | Review and merge PR                                                   |
| 9    | GitHub Actions | Detects version change on main                                        |
| 10   | GitHub Actions | Runs tests, publishes to npm with provenance                          |
| 11   | GitHub Actions | Creates git tag on main                                               |
| 12   | GitHub Actions | Creates GitHub Release                                                |
| 13   | NPM            | Package available for installation                                    |

**Important:** You must have no uncommitted changes when running `npm version` commands.

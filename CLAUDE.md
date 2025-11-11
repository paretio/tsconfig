# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

**@paretio/tsconfig** - A shareable TypeScript configuration package published to npm that provides standardized TypeScript compiler settings for various project types. This package is designed to enforce consistent TypeScript practices across the Paretio ecosystem.

## High-Level Architecture

```
┌─────────────────────────────────────┐
│      TypeScript Config Package       │
│         @paretio/tsconfig            │
└─────────────────────────────────────┘
                ↓ Extends ↓
┌─────────────────────────────────────┐
│        Consumer Projects Use:        │
│  - @paretio/tsconfig (default)       │
│  - @paretio/tsconfig/module (ESM)    │
│  - @paretio/tsconfig/non-module      │
│  - @paretio/tsconfig/react (JSX)     │
└─────────────────────────────────────┘
```

Configuration inheritance structure:
- **base.json** → Core TypeScript settings (strict mode, composite builds)
  - **index.json** → Main export (extends base)
  - **module.json** → ES modules with verbatimModuleSyntax
  - **non-module.json** → CommonJS projects
  - **react.json** → React/JSX projects with modern JSX transform

## Common Development Commands

### Release Management

```bash
# Create beta release (for feature branches)
npm run release:beta

# Create stable releases (from main branch only)
npm run release:patch    # 0.5.0 → 0.5.1
npm run release:minor    # 0.5.0 → 0.6.0
npm run release:major    # 0.5.0 → 1.0.0

# Promote beta to stable
npm version 0.5.0

# Run tests manually
npm run execute-tests
```

### Testing

```bash
# Execute full test suite (runs automatically before releases)
npm run execute-tests

# Test process validates all 5 config exports against:
# - tests/example-project-01-simple (CommonJS)
# - tests/example-project-02-type-module (ESM)
```

## Project Structure

### Key Files

- **src/base.json** - Core TypeScript compiler options with strict mode
- **src/index.json** - Main export point (default configuration)
- **src/module.json** - ES modules configuration
- **src/non-module.json** - CommonJS configuration
- **src/react.json** - React/JSX support configuration
- **utils/execute-tests.mjs** - Integration test runner that validates configs
- **utils/validate-tsconfig.mjs** - TypeScript configuration validator
- **.github/workflows/release.yml** - Automated npm publish workflow

### Test Projects

- **tests/example-project-01-simple/** - CommonJS test project
- **tests/example-project-02-type-module/** - ES modules test project

Both test projects contain various file types (`.js`, `.jsx`, `.ts`, `.mts`, `.cts`) to ensure comprehensive validation.

## Release Workflow

The release process is fully automated through npm scripts and GitHub Actions:

1. **Local:** Run `npm run release:*` or `npm version`
2. **Preversion:** Tests run automatically via `execute-tests.mjs`
3. **Version:** package.json updated and git tag created
4. **Postversion:** Changes pushed to GitHub with tag
5. **GitHub Actions:** Workflow triggered by tag push
6. **CI/CD:** Tests run again, package published to npm with provenance
7. **GitHub:** Release created automatically

**Important:** Never create git tags manually. Always use npm version commands.

## Configuration Details

### Base Configuration Features

- **Strict Mode:** All strict TypeScript checks enabled
- **Composite Builds:** Supports incremental compilation
- **Module Resolution:** Uses `nodenext` for modern Node.js
- **ts-node Support:** Configured with ESM and SWC transpiler
- **Artifacts Directory:** Auto-generated build outputs

### Export Patterns

Consumers can import configurations:
```javascript
// Default (extends base)
"extends": "@paretio/tsconfig"

// ES Modules
"extends": "@paretio/tsconfig/module"

// CommonJS
"extends": "@paretio/tsconfig/non-module"

// React projects
"extends": "@paretio/tsconfig/react"
```

## Testing Approach

The package uses integration testing rather than unit tests:
- Tests run against real TypeScript projects
- Validates actual compilation success
- Tests both CommonJS and ES module systems
- Ensures all exported configs work correctly

Test execution creates temporary directories, installs the package, and runs TypeScript compilation to verify configurations work in real-world scenarios.

## Commit Conventions

**Use Conventional Commits for all commit messages.** This ensures consistent commit history and enables automated changelog generation.

### Commit Format
```
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
```

### Common Types
- **feat:** New feature or configuration addition
- **fix:** Bug fix or configuration correction
- **docs:** Documentation updates only
- **style:** Code formatting (doesn't affect functionality)
- **refactor:** Code restructuring without behavior changes
- **test:** Adding or updating tests
- **chore:** Maintenance tasks, dependency updates
- **build:** Changes to build system or CI configuration
- **perf:** Performance improvements

### Examples
```bash
# Adding new configuration
feat(config): add support for decorators in base config

# Fixing configuration issue
fix(module): correct verbatimModuleSyntax for ESM projects

# Updating documentation
docs: clarify usage instructions for React config

# Updating dependencies
chore(deps): bump ts-node to v11.0.0-beta.1

# Breaking change (triggers major version)
feat(base)!: require TypeScript 5.0 minimum

BREAKING CHANGE: Projects must now use TypeScript 5.0 or higher
```

### Version Impact
- **fix:** Triggers patch release (0.5.0 → 0.5.1)
- **feat:** Triggers minor release (0.5.0 → 0.6.0)
- **BREAKING CHANGE or !:** Triggers major release (0.5.0 → 1.0.0)

## Important Conventions

1. **Conventional Commits** - Use standardized commit messages for all changes
2. **Semantic Versioning** - Follow major.minor.patch with optional pre-release
3. **Beta Testing** - Use beta releases on feature branches before merging
4. **Automated Publishing** - GitHub Actions handles npm publishing
5. **NPM Provenance** - All packages signed for security
6. **EditorConfig** - 2-space indentation, UTF-8, final newlines
7. **Module Systems** - Support both CommonJS and ES modules
8. **TypeScript Strict** - Strict mode enabled by default
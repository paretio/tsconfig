# =============================================================================
# @paretio/tsconfig Makefile
# =============================================================================

.PHONY: test help version-patch version-minor version-major tag-release

# Default target
.DEFAULT_GOAL := help

# -----------------------------------------------------------------------------
# Testing
# -----------------------------------------------------------------------------

## test: Run tests
test:
	npm run execute-tests

# -----------------------------------------------------------------------------
# Release (npm publishing via GitHub Actions)
# -----------------------------------------------------------------------------
# Note: Main branch is protected. Release workflow:
# 1. Run make version-patch/minor/major to bump version (creates commit)
# 2. Push to feature branch and create PR
# 3. After PR merged to main, run make tag-release to create and push tag
# 4. Tag triggers GitHub Actions to publish to npm
# -----------------------------------------------------------------------------

## version-patch: Bump patch version (0.1.0 -> 0.1.1) - commit to PR
version-patch:
	@if [ "$$(git rev-parse --abbrev-ref HEAD)" = "main" ]; then \
		echo "❌ Error: Cannot bump version on main branch (protected)"; \
		echo "   Create a feature branch first: git checkout -b release/v0.x.x"; \
		exit 1; \
	fi
	npm version patch -m "chore: bump version to %s"

## version-minor: Bump minor version (0.1.0 -> 0.2.0) - commit to PR
version-minor:
	@if [ "$$(git rev-parse --abbrev-ref HEAD)" = "main" ]; then \
		echo "❌ Error: Cannot bump version on main branch (protected)"; \
		echo "   Create a feature branch first: git checkout -b release/v0.x.x"; \
		exit 1; \
	fi
	npm version minor -m "chore: bump version to %s"

## version-major: Bump major version (0.1.0 -> 1.0.0) - commit to PR
version-major:
	@if [ "$$(git rev-parse --abbrev-ref HEAD)" = "main" ]; then \
		echo "❌ Error: Cannot bump version on main branch (protected)"; \
		echo "   Create a feature branch first: git checkout -b release/v0.x.x"; \
		exit 1; \
	fi
	npm version major -m "chore: bump version to %s"

## tag-release: Create and push tag from main (triggers npm publish)
tag-release:
	@if [ "$$(git rev-parse --abbrev-ref HEAD)" != "main" ]; then \
		echo "❌ Error: Must be on main branch to create release tag"; \
		echo "   Current branch: $$(git rev-parse --abbrev-ref HEAD)"; \
		echo "   Run: git checkout main && git pull"; \
		exit 1; \
	fi
	@echo "Fetching latest from origin..."
	@git fetch origin main
	@if [ "$$(git rev-parse HEAD)" != "$$(git rev-parse origin/main)" ]; then \
		echo "❌ Error: Local main is not up-to-date with origin/main"; \
		echo "   Local:  $$(git rev-parse --short HEAD)"; \
		echo "   Remote: $$(git rev-parse --short origin/main)"; \
		echo "   Run: git pull origin main"; \
		exit 1; \
	fi
	@echo "✓ On main branch and up-to-date with origin"
	@VERSION=$$(node -p "require('./package.json').version"); \
	echo "Current version: $$VERSION"; \
	echo "Checking if version $$VERSION already exists in npm..."; \
	if npm view @paretio/tsconfig@$$VERSION version 2>/dev/null; then \
		echo "❌ Error: Version $$VERSION already published to npm"; \
		echo "   Package: https://www.npmjs.com/package/@paretio/tsconfig/v/$$VERSION"; \
		echo "   You need to bump the version first (make version-patch in a new PR)"; \
		exit 1; \
	fi; \
	echo "✓ Version $$VERSION not yet published"; \
	echo "Creating tag v$$VERSION..."; \
	git tag v$$VERSION; \
	git push origin v$$VERSION; \
	echo "✓ Tag created and pushed - GitHub Actions will publish to npm"

# -----------------------------------------------------------------------------
# Help
# -----------------------------------------------------------------------------

## help: Show this help message
help:
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

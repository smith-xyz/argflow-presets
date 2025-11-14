#!/bin/bash

# Script to create a language-specific branch from main
# Usage: ./scripts/create-language-branch.sh <language> <version>
# Example: ./scripts/create-language-branch.sh go v1.0.0

set -e

LANG=$1
VERSION=$2

if [ -z "$LANG" ] || [ -z "$VERSION" ]; then
    echo "Usage: $0 <language> <version>"
    echo "Example: $0 go v1.0.0"
    exit 1
fi

BRANCH_NAME="${LANG}-${VERSION}"
TAG_NAME="${LANG}/${VERSION}"

echo "Creating language-specific branch: $BRANCH_NAME"

# Ensure we're on main and up to date
git checkout main
git pull origin main 2>/dev/null || true

# Create new branch from main
git checkout -b "$BRANCH_NAME" main 2>/dev/null || git checkout "$BRANCH_NAME"

# Remove other language directories
LANGUAGES=("go" "rust" "python" "javascript")
for lang in "${LANGUAGES[@]}"; do
    if [ "$lang" != "$LANG" ]; then
        if [ -d "$lang" ]; then
            echo "Removing $lang/ directory"
            git rm -r "$lang/" 2>/dev/null || rm -rf "$lang/"
        fi
    fi
done

# Commit the changes
if [ -n "$(git status --porcelain)" ]; then
    git add -A
    git commit -m "Extract $LANG-only files for $VERSION" || true
fi

# Create tag
echo "Creating tag: $TAG_NAME"
git tag -f "$TAG_NAME" 2>/dev/null || git tag "$TAG_NAME"

echo "Branch $BRANCH_NAME created and tagged as $TAG_NAME"
echo ""
echo "To push to remote:"
echo "  git push origin $BRANCH_NAME"
echo "  git push origin $TAG_NAME"


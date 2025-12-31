#!/bin/bash
# Usage: ./sync.sh <tag_name>
# Example: ./sync.sh v1.0.0

TAG=$1

if [ -z "$TAG" ]; then
  echo "Usage: $0 <tag_name>"
  exit 1
fi

PRIVATE_REPO="yyh0808/memejpg-app-dev"
PUBLIC_REPO="yyh0808/memejpg-app"

echo "Downloading assets from $PRIVATE_REPO @ $TAG..."
gh release download "$TAG" -R "$PRIVATE_REPO" -D ./assets --clobber

if [ $? -ne 0 ]; then
    echo "Failed to download assets. Check if tag exists in private repo."
    exit 1
fi

echo "Creating release in $PUBLIC_REPO @ $TAG..."
gh release create "$TAG" ./assets/* -R "$PUBLIC_REPO" --title "Release $TAG" --notes "Automated release sync from private repo."

if [ $? -ne 0 ]; then
    echo "Failed to create release in public repo."
    exit 1
fi

echo "Sync complete!"
rm -rf ./assets

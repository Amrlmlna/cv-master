#!/bin/bash

# release.sh
# Helper script to create a new release for CV Master

echo -e "\033[0;36mCurrent CV Master Release Helper\033[0m"

# 1. Ask for version
read -p "Enter new version (e.g. 1.0.1): " version
read -p "Enter build number (e.g. 2): " buildNumber

fullVersion="$version+$buildNumber"
echo -e "\033[0;33mPreparing release for version: $fullVersion\033[0m"

# 2. Update pubspec.yaml
# Use sed to replace the version line. 
# We look for "version: " at the start of the line or indented.
# -i.bak creates a backup just in case, typical for BSD/macOS sed but safe here too, or just -i for GNU sed. 
# Git Bash usually has GNU sed.
sed -i "s/^version: .*/version: $fullVersion/" pubspec.yaml

echo -e "\033[0;32mUpdated pubspec.yaml\033[0m"

# 3. Git Operations
echo -e "\033[0;33mCommitting and Tagging...\033[0m"
git add pubspec.yaml
git commit -m "chore: release v$version"
git tag "v$version"

# 4. Push
read -p "Push changes and tag to remote? (y/n): " push
if [ "$push" = "y" ]; then
    git push origin main
    git push origin "v$version"
    echo -e "\033[0;32mPushed to remote! GitHub Action should start now.\033[0m"
else
    echo -e "\033[0;35mDone! Don't forget to push: git push && git push --tags\033[0m"
fi

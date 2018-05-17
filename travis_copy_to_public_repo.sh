#!/bin/bash

set -e
set -x

# Perform the copy from private repo's public/ directory to the public repo if
# and only if we are merging onto the release branch.
if [ "${TRAVIS_PULL_REQUEST}" != "false" ] || [ "${TRAVIS_BRANCH}" != "release" ]; then
  exit 0
fi

PUBLIC_REPO_NAME="test-public"
PUBLIC_REPO_URL="https://github.com/nohle/${PUBLIC_REPO_NAME}.git"

# Clone the public repo.
cd "${HOME}"
git clone "${PUBLIC_REPO_URL}"
cd "${PUBLIC_REPO_NAME}"

# Remove all files in public repo (except .git/).
# Don't error if there are no files.
git rm -r --ignore-unmatch .

# Copy the contents of private repo's "public/" directory
cp -r "${TRAVIS_BUILD_DIR}"/public/. .

# Stage the files for commit
git add .
# Checks that there is a nontrivial diff (and prints it).
# An exit code of 0 means no changes.
# If you don't want to print the diff, use --quiet instead.
# Note: --quiet implies --exit-code.
set +e
git diff --cached --exit-code
exit_code="$?"
set -e
if [ "$exit_code" != 0 ]; then
  # Commit changes with version number commit message
  git commit -m "Version: ${VERSION_NUMBER}"
  # Push changes to public GitHub repo
  git push
fi

# Cleanup
cd "${TRAVIS_BUILD_DIR}"
rm -rf "${HOME}/${PUBLIC_REPO_NAME}"

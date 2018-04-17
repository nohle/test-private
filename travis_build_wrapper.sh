#!/bin/bash

# Fail on any error.
set -e
# Display commands being run.
set -x

# Runs when a PR against the release branch is merged
function release_pr_merged {
  export BUILD_VERSION="PR-merged-${TRAVIS_BUILD_NUMBER}"
  ./build.sh
}

# Runs when a PR against the release branch is opened
function release_pr_opened {
  export BUILD_VERSION="PR-opened-${TRAVIS_BUILD_NUMBER}"
  ./build.sh
}

# Default job
function default_build_job {
  export BUILD_VERSION="dev"
  ./build.sh
}

if [ "${TRAVIS_PULL_REQUEST}" = "false" ] && [ "${TRAVIS_BRANCH}" = "release" ]; then
  release_pr_merged;
elif [ "${TRAVIS_PULL_REQUEST}" != "false" ] && [ "${TRAVIS_BRANCH}" = "release" ]; then
  release_pr_opened;
else
  default_build_job;
fi

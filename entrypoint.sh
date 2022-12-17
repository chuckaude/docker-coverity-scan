#!/bin/bash

# Docker entrypoint script for Coverity scan image

# requires the following environment variables to be set:
#	COV_URL = Coverity server URL
#	COV_USER = Coverity username
#	COVERITY_PASSPHRASE = Coverity password or auth token key
#
# sets the following based on git repo information
#	COV_PROJECT = REPONAME
#	COV_STREAM = REPONAME-BRANCHNAME
# will auto-create project & stream if user has access

fatal() {
	echo "FATAL: $1"
	exit 1
}

[ $# -ne 2 ] && fatal "USAGE: docker run --rm -e COV_URL=\$COV_URL -e COV_USER=\$COV_USER -e COVERITY_PASSPHRASE=\$COVERITY_PASSPHRASE \$TAG \$REPO_URL \$BRANCH"

[ -z "$COV_URL" ] && fatal "COV_URL not set"
[ -z "$COV_USER" ] && fatal "COV_USER not set"
[ -z "$COVERITY_PASSPHRASE" ] && fatal "COVERITY_PASSPHRASE not set"

git clone --depth 1 --branch $2 $1 workspace
[ $? -ne 0 ] && fatal "git clone error"

set -ex
cd workspace
COV_PROJECT=$(basename -s .git $(git config --get remote.origin.url))
COV_STREAM=$COV_PROJECT-$(git branch --show-current)
coverity scan -o commit.connect.url=$COV_URL -o commit.connect.project=$COV_PROJECT -o commit.connect.stream=$COV_STREAM

exit 0

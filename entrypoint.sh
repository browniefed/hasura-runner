#!/bin/sh

RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

debug() {
  printf "ℹ️ ${CYAN}%s${NC}\n", "$1"
}

warn() {
  printf "⚠️ ${YELLOW}%s${NC}\n", "$1"
}

error() {
  printf "❌ ${RED}%s${NC}\n", "$1"
}

# If a CLI version was given to Github Action inputs, then use that, otherwise default to latest release
if [ -z "$HASURA_CLI_VERSION" ]; then
  warn "Hasura CLI version not provided, downloading latest release"
  hasura_cli_download_url="https://github.com/hasura/graphql-engine/releases/latest/download/cli-hasura-linux-amd64"
else
  debug "Downloading Hasura CLI $HASURA_CLI_VERSION"
  hasura_cli_download_url="https://github.com/hasura/graphql-engine/releases/download/$HASURA_CLI_VERSION/cli-hasura-linux-amd64"
fi

# Download the Hasura CLI binary
wget --quiet --output-document /usr/local/bin/hasura "$hasura_cli_download_url" || {
  error 'Failed downloading Hasura CLI'
  exit 1
}

debug "Making Hasura CLI executable"
# Make it executable
chmod +x /usr/local/bin/hasura || {
  error 'Failed making CLI executable'
  exit 1
}


command="hasura $* --endpoint $HASURA_MIGRATIONS_ENABLED"

if [ -n "$HASURA_ADMIN_SECRET" ]; then
    command="$command --admin-secret $HASURA_ADMIN_SECRET"
fi

# CD into Hasura project root directory, if given and not current directory
if [ -n "$PATH_TO_HASURA_PROJECT_ROOT" ]; then
  debug "cd'ing to Hasura project root at $PATH_TO_HASURA_PROJECT_ROOT"
  cd "$PATH_TO_HASURA_PROJECT_ROOT" || {
    error "Failed to cd into directory $PATH_TO_HASURA_PROJECT_ROOT"
    exit 1
  }
else
  warn "No path to Hasura project root given, using top-level repo directory"
fi

# secrets can be printed, they are protected by Github Actions
echo "Executing '$command' from '${HASURA_WORKDIR:-./}'"

sh -c "$command"
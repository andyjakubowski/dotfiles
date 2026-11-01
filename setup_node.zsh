#!/usr/bin/env zsh

set -eu

echo "\n<<< Starting Node Setup >>>\n"

# Node versions are managed with `n`, which is in the Brewfile.
# Work when invoked directly, before interactive shell configuration is loaded.
export N_PREFIX="${N_PREFIX:-$HOME/.n}"
export PATH="$N_PREFIX/bin:$PATH"

if [[ -x "$N_PREFIX/bin/node" && -x "$N_PREFIX/bin/npm" ]]; then
  echo "Node $("$N_PREFIX/bin/node" --version) & NPM $("$N_PREFIX/bin/npm" --version) already installed with n"
else
  echo "Installing Node & NPM with n..."
  n latest
fi

if [[ ! -x "$N_PREFIX/bin/node" || ! -x "$N_PREFIX/bin/npm" ]]; then
  echo "Node and npm were not installed in $N_PREFIX/bin; refusing to use another runtime." >&2
  exit 1
fi


# Install Global NPM Packages
npm install --global trash-cli
npm install --global yarn
npm install --global @anthropic-ai/claude-code

echo "Global NPM Packages Installed:"
npm list --global --depth=0


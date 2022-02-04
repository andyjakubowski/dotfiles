#!/usr/bin/env zsh

echo "\n<<< Starting Homebrew Setup >>>\n"

if exists brew; then
  echo "brew exists, skipping install"
else
  echo "brew doesn't exist, continuing with install"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

  # Add Homebrew to PATH if running this script on an ARM macOS
  echo "Start another shell session or $ source ~/.zshrc to put Homebrew on your current shell’s PATH."
  OS="$(uname)"
  UNAME_MACHINE="$(/usr/bin/uname -m)"
  if [[ "${OS}" == "Darwin" && "${UNAME_MACHINE}" == "arm64" ]]
  then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi


# TODO: Keep an eye out for a different `--no-quarantine` solution.
# Currently, you can't do `brew bundle --no-quarantine` as an option.
# export HOMEBREW_CASK_OPTS="--no-quarantine --no-binaries"
# https://github.com/Homebrew/homebrew-bundle/issues/474

# HOMEBREW_CASK_OPTS is exported in `zshenv` with
# `--no-quarantine` and `--no-binaries` options,
# which makes them available to Homebrew for the
# first install (before our `zshrc` is sourced).

# Install packages, casks, and Mac App Store apps
# based on the Brewfile in this repo
brew bundle --verbose

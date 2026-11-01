#!/usr/bin/env zsh

set -eu

echo "\n<<< Starting ZSH Setup >>>\n"

# Homebrew installs the newer Z shell through the Brewfile.
brew_zsh="$(brew --prefix)/bin/zsh"
if [[ ! -x "$brew_zsh" ]]; then
  echo "Homebrew zsh is missing at $brew_zsh; run Homebrew setup first." >&2
  exit 1
fi

# Register and select the user's login shell. Keep the system /bin/sh unchanged.
if grep -Fxq -- "$brew_zsh" /etc/shells; then
  echo "$brew_zsh already exists in /etc/shells"
else
  echo "Enter superuser (sudo) password to edit /etc/shells"
  printf '%s\n' "$brew_zsh" | sudo tee -a /etc/shells >/dev/null
fi

if [[ "${SHELL:-}" != "$brew_zsh" ]]; then
  chsh -s "$brew_zsh"
fi

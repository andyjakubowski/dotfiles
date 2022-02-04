#!/usr/bin/env zsh

echo "\n<<< Starting ZSH Setup >>>\n"

# macOS comes with the Z shell
# But Homebrew has a newer version, and that’s what we’d like to use

# Installation of Homebrew zsh here unnecessary; it's installed from the Brewfile.

# Add Homebrew zsh to list of login shells in /etc/shells
# https://stackoverflow.com/a/4749368/1341838
if grep -Fxq $(brew --prefix)/bin/zsh '/etc/shells'; then
  echo $(brew --prefix)/bin/zsh already exists in /etc/shells
else
  echo "Enter superuser (sudo) password to edit /etc/shells"
  echo $(brew --prefix)/bin/zsh | sudo tee -a '/etc/shells' >/dev/null
fi

# Set Homebrew zsh as the login shell for this user
if [ "$SHELL" = $(brew --prefix)/bin/zsh ]; then
  echo \$SHELL is already $(brew --prefix)/bin/zsh
else
  echo "Enter user password to change login shell"
  chsh -s '$(brew --prefix)/bin/zsh'
fi

# Make built-in zsh (/bin/zsh) the default non-interactive shell
# Seems like it's not possible to make Homebrew zsh
# the default here, so we settle for the built-in
if sh --version | grep -q zsh; then
  echo '/private/var/select/sh already linked to /bin/zsh'
else
  echo "Enter superuser (sudo) password to symlink sh to zsh"
  # Looked cute, might delete later, idk
  sudo ln -sfv /bin/zsh /private/var/select/sh

  # I'd like for this to work instead.
  # sudo ln -sfv $(brew --prefix)/bin/zsh /private/var/select/sh
fi
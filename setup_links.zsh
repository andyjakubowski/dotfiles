#!/usr/bin/env zsh

echo "\n<<< Setting up useful links >>>\n"

echo "Putting a link to PlistBuddy on the path"
sudo ln -fsv /usr/libexec/PlistBuddy /usr/local/bin/plistbuddy

echo "Symlink Homebrew postgresql@15’s files into Homebrew’s prefix. The --force option is necessary because postgresql@15 is keg-only"
brew link --force postgresql@15

echo "\n<<< ✔ Link setup done >>>\n"

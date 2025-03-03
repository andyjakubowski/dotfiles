#!/usr/bin/env zsh

echo "\n<<< Setting up useful links >>>\n"

echo "Putting a link to PlistBuddy on the path"
sudo ln -fsv /usr/libexec/PlistBuddy /usr/local/bin/plistbuddy

echo "\n<<< ✔ Link setup done >>>\n"

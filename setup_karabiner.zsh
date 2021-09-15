#!/usr/bin/env zsh

echo "\n<<< Starting Karabiner Elements (keyboard customizer) Setup >>>\n"

if ! sudo --validate --non-interactive 1>/dev/null 2>&1; then
    echo "Enter superuser (sudo) password to apply the user Karabiner Elements config to all users on this Mac:"
fi

sudo '/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --copy-current-profile-to-system-default-profile

echo "\n<<< ✔ Karabiner Elements Setup Done >>>\n"

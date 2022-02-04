# dotfiles

I learned about dotfiles from [dotfiles.eieio.xyz](http://dotfiles.eieio.xyz/). The repo for that course is at [https://github.com/eieioxyz/dotfiles_macos](https://github.com/eieioxyz/dotfiles_macos).

## Decommission Computer

### `brew bundle dump`

You might have installed apps on your Mac that aren’t yet reflected in your dotfiles repo. Run `brew bundle dump` and compare the resulting file with the `Brewfile` in your repo. You can also override the `Brewfile` and `diff` it. There might be apps you don’t want on your new Mac, so make sure you remove those from the `Brewfile`.

### Pomodoro

1. Back up the `~/Library/Application Support/Pomodoro` directory, which holds an SQL log of all past pomodoros.
2. `Pomodoro Stats > Log`, Export as text file, for good measure.
3. Back up global and local stats keys from `com.ugolandini.Pomodoro` into this repo with `defaults read com.ugolandini.Pomodoro > ~/.dotfiles/pomodoro-defaults-dump.txt`. Then, update the `defaults write com.ugolandini.Pomodoro ...` statements in `setup_macos.zsh` with the updated data. This is the one non-idempotent part of this repo, so you’ll have to comment out these statements after the initial install on a new machine to avoid resetting your Pomodoro stats.

### Visual Studio Code

Make sure [Settings Sync]() is turned on, and that you’re syncing all of the following:

- Settings
- Keyboard Shortcuts for each platform
- User Snippets
- Extensions
- UI State

### Deactivate devices and licenses

- Kindle for Mac > Preferences > General > Deregister

## Restore Instructions

1. `xcode-select --install` (Command Line Tools are required for Git and Homebrew)
2. `git clone https://github.com/andyjakubowski/dotfiles.git ~/.dotfiles`. We'll start with `https` but switch to `ssh` after everything is installed.
3. `cd ~/.dotfiles`
4. If necessary, `git checkout <another_branch>`.
5. Do one last Software Audit by editing [Brewfile](Brewfile) directly.
6. [`./install`](install)
7. Comment out the `defaults write com.ugolandini.Pomodoro ...` statements that reset Pomodoro stats. You only want to do that part once.
8. Restart computer.
9. Setup up Dropbox (use multifactor authentication!) and allow files to sync before setting up dependent applications. Alfred settings are stored here.
10. [Generate ssh key](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh), add to GitHub, and switch remotes.

```zsh
# Generate SSH key in default location (~/.ssh/config)
ssh-keygen -t rsa -b 4096 -C "477212+andyjakubowski@users.noreply.github.com"

# Start the ssh-agent
eval "$(ssh-agent -s)"

# Create config file with necessary settings
<< EOF > ~/.ssh/config
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_rsa
EOF

# Add private key to ssh-agent
ssh-add -K ~/.ssh/id_rsa

# Copy public key and add to github.com > Settings > SSH and GPG keys
pbcopy < ~/.ssh/id_rsa.pub

# Test SSH connection, then verify fingerprint and username
# https://help.github.com/en/github/authenticating-to-github/testing-your-ssh-connection
ssh -T git@github.com

# Switch from HTTPS to SSH
git remote set-url origin git@github.com:andyjakubowski/dotfiles.git
```

## Things you have to do manually

- Safari > Debug > Tab Ordering > Position of New Tabs > After Last Tab

### Visual Studio Code

1. Turn on Settings Sync, and wait for it to finish
2. Activate Wallaby license

### Pomodoro

1. Copy `~/Dropbox/Pomodoro/Pomodoro.app` to `/Applications`.
2. Copy the contents of `~/Dropbox/Pomodoro/Log` to `~/Library/Application Support/Pomodoro`.

Remember the _new pomodoro_ keyboard shortcut: `Control-Option-Command-UpArrow`.

### Dropbox

1. Log in.
2. Wait until all files have synced.

### Alfred

https://www.alfredapp.com/help/getting-started/migration/

1. `System Preferences > Keyboard > Shortcuts > Spotlight > Show Spotlight search (cmd+space)` uncheck.
2. `Alfred Preferences > Powerpack` add License.
3. `Alfred Preferences > General > Request Permissions`.
4. `Alfred Preferences > General > Alfred Hotkey` change to `cmd+space`.
5. `Alfred Preferences > Advanced > Set preferences folder` and set to `~/Dropbox/Alfred`.

### Dash

1. `Dash Preferences > Purchase` add license from `~/Dropbox/Dash`.
2. `Dash Preferences > General > Set up syncing...` and set to `~/Dropbox/Dash`.

### Menu bar icons

Because setting these via `defaults` doesn’t seem to work in Big Sur, you need to do it manually. Or, look into GUI manipulation with AppleScript; that will of course be prone to error if Apple changes the UI of those preference panes.

1. `System Preferences > Sound > Sound Effects > Show volume in menu bar` check.
2. `System Preferences > Bluetooth > Show volume in menu bar` check.

Potential AppleScript automation:

- https://macscripter.net/viewtopic.php?id=46820
- https://latenightsw.com/big-sur/
- https://apple.stackexchange.com/questions/422165/applescript-system-preferences-automation
- https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/introduction/ASLR_intro.html

### Notational Velocity

1. `Notational Velocity Preferences > Notes > Read notes from folder...`, set to `~/Dropbox/Notational Velocity`.
2. Automatically setting bookmarks using `defaults` doesn’t seem to work — you’ll need to do it manually.

### Things

1. `Things Preferences > Things Cloud`, log in.

### Boostnote

1. `Boostnote Preferences > Storage`, click Unlink next to the default storage location.
2. `Boostnote Preferences > Storage`, click _Add Storage Location_, set to `~/Dropbox/Boostnote`.

### Divvy

1. `Divvy Preferences > Start Divvy at login`, check.

### Login items

- `System Preferences > Users & Groups > Login Items`, make sure the list contains the following:
  - Divvy
  - Pomodoro
  - Alfred 4
  - Dropbox

## Todo

- set up Network Link Conditioner
- automate font installation

## Comments

- The `Brewfile` in this repo installs Sketch 74. Update the `Brewfile` if you need the latest version.

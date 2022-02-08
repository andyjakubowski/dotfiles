# dotfiles

My dotfiles for macOS. You could get some of this setup to work on Linux, but you’d have to disable the installation of Homebrew casks, and Mac App Store apps. The setup scripts also include some macOS-only conveniences, like adding Homebrew to PATH on Apple Silicon Macs.

I learned about dotfiles from [dotfiles.eieio.xyz](http://dotfiles.eieio.xyz/). The repo for that course is at [https://github.com/eieioxyz/dotfiles_macos](https://github.com/eieioxyz/dotfiles_macos).

## Decommission Computer

### Commit and push to remote repos

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

1. `xcode-select --install`. Running this will prompt the installation of the command line developer tools. Command Line Tools are required for Git and Homebrew. This might take about 15 minutes.
2. If you’re on an ARM macOS (for example, M1): `softwareupdate --install-rosetta`. This will let you use apps built for a Mac with an Intel processor.
3. `git clone https://github.com/andyjakubowski/dotfiles.git ~/.dotfiles`. We'll start with `https` but switch to `ssh` after everything is installed.
4. `cd ~/.dotfiles`
5. This repo only has the `main` branch. Some people split their dotfiles repos into separate branching depending on things like the operating system. In that case, `git checkout <another_branch>`.
6. Do one last Software Audit by editing [Brewfile](Brewfile) directly.
7. Sign into the Mac App Store.
8. [`./install`](install)
9. Comment out the `defaults write com.ugolandini.Pomodoro ...` statements that reset Pomodoro stats. You only want to do that part once.
10. Restart computer.
11. Setup up Dropbox (use multifactor authentication!) and allow files to sync before setting up dependent applications. Dependent apps: Alfred, Dash, Pomodoro, Notational Velocity, Boostnote.
12. [Generate ssh key](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh), add to GitHub, and switch remotes.

```zsh
# Generate SSH key in default location (~/.ssh/config)
ssh-keygen -t ed25519 -C "477212+andyjakubowski@users.noreply.github.com"

# Start the ssh-agent
eval "$(ssh-agent -s)"

# Create config file with necessary settings
<< EOF > ~/.ssh/config
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF

# Add private key to ssh-agent
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# Copy public key to your clipboard
pbcopy < ~/.ssh/id_ed25519.pub

# Add public key to github.com > Settings > SSH and GPG keys > New SSH key

# Test SSH connection, then verify fingerprint and username
# https://help.github.com/en/github/authenticating-to-github/testing-your-ssh-connection
ssh -T git@github.com

# Verify the fingerprint you see matches one of these: https://docs.github.com/en/github/authenticating-to-github/githubs-ssh-key-fingerprints

# Switch from HTTPS to SSH
git remote set-url origin git@github.com:andyjakubowski/dotfiles.git
```

## Things you have to do manually

### Safari

- Safari > Debug > Tab Ordering > Position of New Tabs > After Last Tab
- Enable the password manager extension

### Remap Caps Lock to Escape

System Preferences > Keyboard > Modifier Keys...

### Karabiner Elements

Give the app the permissions it asks for.

### Password manager

- Log in.
- Enable the Safari extension.

### Dropbox

1. Log in.
2. Wait until all files have synced.

### Visual Studio Code

1. Turn on Settings Sync, and wait for it to finish
2. Activate Wallaby license
3. Activate Quokka license

### Sound and Bluetooth

Because setting these via `defaults` doesn’t seem to work in Big Sur, you need to do it manually. Or, look into GUI manipulation with AppleScript; that will of course be prone to error if Apple changes the UI of those preference panes.

- `System Preferences > Sound > Sound Effects > Play sound on startup`: uncheck.
- `System Preferences > Sound > Sound Effects > Show Sound menu bar`: check, set to always.
- `System Preferences > Bluetooth > Show Bluetooth in menu bar` check.

Potential AppleScript automation:

- https://macscripter.net/viewtopic.php?id=46820
- https://latenightsw.com/big-sur/
- https://apple.stackexchange.com/questions/422165/applescript-system-preferences-automation
- https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/introduction/ASLR_intro.html

### Things

1. `Things Preferences > Things Cloud`, log in.

### Divvy

1. `Divvy Preferences > Start Divvy at login`, check.

### Pomodoro

1. Copy `~/Dropbox/Pomodoro/Pomodoro.app` to `/Applications`.
2. Copy the contents of `~/Dropbox/Pomodoro/Log` to `~/Library/Application Support/Pomodoro`.

Remember the _new pomodoro_ keyboard shortcut: `Control-Option-Command-UpArrow`.

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

### Notational Velocity

1. `Notational Velocity Preferences > Notes > Read notes from folder...`, set to `~/Dropbox/Notational Velocity`.
2. Automatically setting bookmarks using `defaults` doesn’t seem to work — you’ll need to do it manually.

### Boostnote

1. `Boostnote Preferences > Storage`, click Unlink next to the default storage location.
2. `Boostnote Preferences > Storage`, click _Add Storage Location_, set to `~/Dropbox/Boostnote`.

### Login items

- `System Preferences > Users & Groups > Login Items`, make sure the list contains the following:
  - Divvy
  - Pomodoro
  - Alfred 4
  - Dropbox

## Resolving issues

### Aliases

When you run `./install`, files like `zshenv` and `zshrc` will be linked before any software is installed. This means your [Z Shell](https://zsh.sourceforge.io/) will start using certain aliases that are configured in those files. For example: `alias ls='exa -laFh --git'`.

These aliases rely on non-standard software being installed. But if this for whatever reason the software fails to install when you run `./install`, You’ll end up with errors in your terminal like `zsh: command not found: exa`.

Run `where ls` to see the full path to the original, non-aliased `ls`. Then you’d run something like `/bin/ls /bin` instead.

### Apple Silicon

If you’re setting up a new Mac that uses Apple’s CPUs like the M1, you may need to install [Rosetta](https://support.apple.com/en-gb/HT211861) to run software built for Intel Macs.

## Comments

- The `Brewfile` in this repo installs Sketch 74. Update the `Brewfile` if you need the latest version.

## Todo

- set up Network Link Conditioner
- automate font installation
- Fix issue with `nano` on macOS Monterey where nanorc uses `/usr/local/share/nano`, but this path doesn’t seem to exist.

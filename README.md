# dotfiles

## Decommission Computer

### Pomodoro

1. Back up the `~/Library/Application Support/Pomodoro` directory, which holds an SQL log of all past pomodoros.
2. `Pomodoro Stats > Log`, Export as text file, for good measure.
3. Back up global and local stats keys from `com.ugolandini.Pomodoro` into this repo. Otherwise, old stats will be applied when the installation script runs.

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

## Todo

- set up Network Link Conditioner
- automate font installation

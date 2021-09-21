# dotfiles

## Things you have to do manually

- Safari > Debug > Tab Ordering > Position of New Tabs > After Last Tab

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

## Todo

- set up Network Link Conditioner
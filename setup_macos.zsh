#!/usr/bin/env zsh

echo "\n<<< Starting macOS Setup >>>\n"

osascript -e 'tell application "System Preferences" to quit'

###############################################################################
# Safari                                                                      #
###############################################################################

if ! command ls ~/Library/Containers/com.apple.Safari 1>/dev/null 2>&1; then
    echo "\n🚨 There’s a PROBLEM: 🚨"
    echo "Setting Safari preferences requires Full Disk Access for the app running this process.\n"
    echo "This can be the Terminal, iTerm, VS Code, or whatever other app you’re using to run this."
    echo "Enable Full Disk Access for that app in System Preferences > Security & Privacy > Privacy > Full Disk Access, and run ./install again."
    echo "(nothing will break, the script is idempotent)"
    echo "Full Disk Access is required because Safari is sandboxed and because of macOS’s System Integrity Protection."
    echo "Read more: https://lapcatsoftware.com/articles/containers.html\n"
    exit 1
fi

# New windows and tabs open with an empty page
defaults write com.apple.Safari NewWindowBehavior -bool true
defaults write com.apple.Safari NewTabBehavior -bool true

# Make DuckDuckGo the default search engine
defaults write com.apple.Safari SearchProviderShortName -string "DuckDuckGo"

# Show bookmarks in the sidebar
defaults write com.apple.Safari SidebarViewModeIdentifier -string "Bookmarks"

# Disable all search suggestions and preloading top hits
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true
defaults write com.apple.Safari PreloadTopHit -bool false

# Press Tab to highlight each item on a web page
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Prevent Safari from opening ‘safe’ files automatically after downloading
# defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Hide Safari’s Favorites
defaults write com.apple.Safari ShowFavoritesUnderSmartSearchField -bool false

# Hide Safari’s sidebar in Top Sites
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

# Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Remove useless icons from Safari’s bookmarks bar
# defaults write com.apple.Safari ProxiesInBookmarksBar "()"

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write -g WebKitDeveloperExtras -bool true

# Enable continuous spellchecking
# defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
# Disable auto-correct
# defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

# Disable AutoFill
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# Warn about fraudulent websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Show hidden files in Finder, Open/Save dialogs, everywhere
defaults write -g AppleShowAllFiles -bool true

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show all filename extensions
defaults write -g AppleShowAllExtensions -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_DefaultIconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy dateModified" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_DefaultIconViewSettings:arrangeBy dateModified" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy dateModified" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy dateModified" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_DefaultIconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

# Finder > View > Show Path Bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Finder > Preferences > General > New Finder windows show:
defaults write com.apple.finder NewWindowTarget -string 'PfLo'
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Downloads"

# Enable spring loading for directories (11.5.2 default: true)
defaults write -g com.apple.springing.enabled -bool true

# Reduce the spring loading delay for directories (11.5.2 default: 0.5)
defaults write -g com.apple.springing.delay -float 0.2

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv` (icon), `Nlsb` (list), `clmv` (column), `glyv` (gallery)
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict-add \
	MetaData -bool true \
	Comments -bool true \
	OpenWith -bool true \
	Preview -bool false

###############################################################################
# Dock                                                                        #
###############################################################################

# System Preferences > Dock

# The position of the Dock on the screen
defaults write com.apple.dock orientation -string "bottom"

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Make dock icons bigger on hover
# defaults write com.apple.dock magnification -bool true

# Dock icon size
defaults write com.apple.dock tilesize -int 48

# Dock icon size on hover
# defaults write com.apple.dock largesize -int 60

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Wipe all app icons from the Dock
# We want only open apps to show up in the Dock
defaults write com.apple.dock persistent-apps -array

# Show only open applications in the Dock
# defaults write com.apple.dock static-only -bool true

# Don’t show indicator dots for open applications
defaults write com.apple.dock show-process-indicators -bool true

# How quickly the Dock animates into view
defaults write com.apple.dock autohide-time-modifier -float 0.7

# How long it takes before the Dock animation starts
defaults write com.apple.dock autohide-delay -float 0.0

# Hide recent apps
defaults write com.apple.dock show-recents -bool false

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen

# -modifier means you have to hold down the Option key

# Top left screen corner
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0

# Top right screen corner → Desktop
defaults write com.apple.dock wvous-tr-corner -int 2
defaults write com.apple.dock wvous-tr-modifier -int 0

# Bottom right screen corner → Start screen saver
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.dock wvous-br-modifier -int 0

# Bottom left screen corner → Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 3
defaults write com.apple.dock wvous-bl-modifier -int 0

###############################################################################
# Activity Monitor                                                            #
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show All Processes, Hierarchically
defaults write com.apple.ActivityMonitor ShowCategory -int 101

# Sort Activity Monitor results by CPU usage
/usr/libexec/PlistBuddy -c "Set :UserColumnSortPerTab:0:direction 0" ~/Library/Preferences/com.apple.ActivityMonitor.plist
/usr/libexec/PlistBuddy -c "Set :UserColumnSortPerTab:0:sort CPUUsage" ~/Library/Preferences/com.apple.ActivityMonitor.plist

###############################################################################
# Language & Region                                                           #
###############################################################################

# Monday is the first day of the week
defaults write -g AppleFirstWeekday -dict gregorian -int 2

# 12-Hour Clock
defaults write -g AppleICUForce24HourTime -bool false

# Temperature in Celsius
defaults write -g AppleTemperatureUnit -string "Celsius"

###############################################################################
# Other                                                                       #
###############################################################################

# Disable System Preferences > General > Close windows when quitting an app
defaults write -g NSQuitAlwaysKeepsWindows -bool true

# Allow repeated calls when Do Not Disturb is turned on
defaults write com.apple.messages.facetime FaceTimeTwoTimeCallthroughEnabled -bool true

# When switching apps, switch to a Space with open windows for the app
defaults write -g AppleSpacesSwitchOnActivate -bool true

# Ask to keep changes when closing documents
defaults write -g NSCloseAlwaysConfirmsChanges -bool true

# Always prefer tabs when opening documents
defaults write -g AppleWindowTabbingMode -string always

# Adjust toolbar title rollover delay
defaults write -g NSToolbarTitleViewRolloverDelay -float 0

# Expand save panel by default
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write -g PMPrintingExpandedStateForPrint -bool true
defaults write -g PMPrintingExpandedStateForPrint2 -bool true

# Disable automatic text checking, correction, and substitution
defaults write -g WebAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticTextCompletionEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false

# Touch Bar shows expanded control strip
defaults write com.apple.touchbar.agent PresentationModeGlobal fullControlStrip

# Fast keyboard repeat rate
# 2 is the fastest you can get in the GUI
defaults write -g KeyRepeat -int 2
# 15 is the fastest you can get in the GUI
defaults write -g InitialKeyRepeat -int 15

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write -g AppleKeyboardUIMode -int 2

# Increase sound quality for Bluetooth headphones/headsets
# Not sure how this works exactly, keeping it commented out for now
# defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
# Follow the keyboard focus while zoomed in
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

# Stop iTunes from responding to the keyboard media keys
# launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

# Disable the [ ] line marks at the beginning and end of each line in Terminal
defaults write com.apple.Terminal ShowLineMarks -int 0

# Don’t display the confirmation prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

# Show function keys in Touch Bar instead of app controls in Visual Studio Code
defaults write com.apple.touchbar.agent PresentationModePerApp -dict-add com.microsoft.VSCode -string functionKeys

###############################################################################
# Input Sources                                                               #
###############################################################################

# Add US English and Polish to the list of preferred languages
if ! defaults read -g AppleLanguages | grep -i --silent pl; then
    defaults write -g AppleLanguages -array-add -string pl-US
fi
# defaults write .GlobalPreferences_m AppleLanguages -array -string en-US -string pl-US

# Add Polish - Pro as an input source if it's not in the list of input sources
if ! defaults read com.apple.HIToolbox AppleEnabledInputSources | grep --silent 'Polish Pro'; then
    /usr/libexec/PlistBuddy -c "Add :AppleEnabledInputSources:0 dict" ~/Library/Preferences/com.apple.HIToolbox.plist
    /usr/libexec/PlistBuddy -c "Add :AppleEnabledInputSources:0:InputSourceKind string 'Keyboard Layout'" ~/Library/Preferences/com.apple.HIToolbox.plist
    /usr/libexec/PlistBuddy -c "Add :AppleEnabledInputSources:0:'KeyboardLayout ID' integer 30788" ~/Library/Preferences/com.apple.HIToolbox.plist
    /usr/libexec/PlistBuddy -c "Add :AppleEnabledInputSources:0:'KeyboardLayout Name' string 'Polish Pro'" ~/Library/Preferences/com.apple.HIToolbox.plist
fi

# Show Input menu in menu bar
defaults write com.apple.TextInputMenu visible -bool true
defaults write com.apple.TextInputMenuAgent "NSStatusItem Visible Item-0" -bool true

###############################################################################
# Keyboard Shortcuts - macOS                                                  #
###############################################################################

# System keyboard shortcuts are encoded with ASCII codes, key codes, and decimal representations of bitwise ORs of modifier key masks
# https://theasciicode.com.ar
# https://manytricks.com/keycodes/
# https://opensource.apple.com/source/IOHIDFamily/IOHIDFamily-1090.220.12/IOHIDSystem/IOKit/hidsystem/IOLLEvent.h.auto.html

# Disable "Turn Dock Hiding On/Off"
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:52:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# Disable "Show Spotlight search"
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# Enable "Move focus to the Dock"
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:8:enabled true" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# Disable "Move focus to active or next window"
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:9:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# Disable "Move focus to the window toolbar"
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:10:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# Disable "Move focus to the floating window"
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:11:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# Disable "Select the previous input source"
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:60:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# Disable "Save picture of the Touch Bar as a file"
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:181:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# Disable "Copy picture of the Touch Bar to the clipboard"
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:182:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

###############################################################################
# Keyboard Shortcuts - 3rd party apps                                         #
###############################################################################

# @ Command
# $ Shift
# ~ Option
# ^ Control 
# Example: "@~K" is Command-Option-K

# ↑ U+2191
# ↓ U+2193
# ← U+2190
# → U+2192
# https://unicode-table.com/en/#003E


# Sketch

# Add Sketch to the list of apps accepting keyboard shortcuts
if ! defaults read com.apple.universalaccess com.apple.custommenu.apps | grep -i --silent bohemiancoding.sketch3; then
    defaults write com.apple.universalaccess com.apple.custommenu.apps -array-add -string com.bohemiancoding.sketch3
fi

defaults write com.bohemiancoding.sketch3 NSUserKeyEquivalents -dict-add 'Mask with Selected Shape' -string '@$m'
# Wrapping Arrange->Align->Top in single quotes only causes a parsing error. Additionally wrapping it in double quotes works fine — no idea why...
defaults write com.bohemiancoding.sketch3 NSUserKeyEquivalents -dict-add "'Arrange->Align->Top'" -string '@^↑'
defaults write com.bohemiancoding.sketch3 NSUserKeyEquivalents -dict-add "'Arrange->Align->Bottom'" -string '@^↓'
defaults write com.bohemiancoding.sketch3 NSUserKeyEquivalents -dict-add "'Arrange->Align->Left'" -string '@^←'
defaults write com.bohemiancoding.sketch3 NSUserKeyEquivalents -dict-add "'Arrange->Align->Right'" -string '@^→'
# Technically Arrange->Align->Vertically, but that doesn’t overwrite the default shortcut. A single word shortcut does; not sure why
defaults write com.bohemiancoding.sketch3 NSUserKeyEquivalents -dict-add 'Vertically' -string '$@y'
# Technically Arrange->Align->Horizontally, but that doesn’t overwrite the default shortcut. A single word shortcut does; not sure why
defaults write com.bohemiancoding.sketch3 NSUserKeyEquivalents -dict-add 'Horizontally' -string '$@x'
defaults write com.bohemiancoding.sketch3 NSUserKeyEquivalents -dict-add 'Make Grid' -string '$@a'
defaults write com.bohemiancoding.sketch3 NSUserKeyEquivalents -dict-add "'Canvas->Layout Settings...'" -string '$@n'
defaults write com.bohemiancoding.sketch3 NSUserKeyEquivalents -dict-add "'Combine->Flatten'" -string '$@f'
defaults write com.bohemiancoding.sketch3 NSUserKeyEquivalents -dict-add 'Copy SVG Code' -string '$@s'
defaults write com.bohemiancoding.sketch3 NSUserKeyEquivalents -dict-add 'Detach from Symbol' -string '$@w'

# Safari

# Add Safari to the list of apps accepting keyboard shortcuts
if ! defaults read com.apple.universalaccess com.apple.custommenu.apps | grep -i --silent com.apple.Safari; then
    defaults write com.apple.universalaccess com.apple.custommenu.apps -array-add -string com.apple.Safari
fi

defaults write com.apple.Safari NSUserKeyEquivalents -dict-add 'Export as PDF...' -string '$@s'
defaults write com.apple.Safari NSUserKeyEquivalents -dict-add 'Show Reader' -string '~^r'

# Mail

# Add Mail to the list of apps accepting keyboard shortcuts
if ! defaults read com.apple.universalaccess com.apple.custommenu.apps | grep -i --silent com.apple.mail; then
    defaults write com.apple.universalaccess com.apple.custommenu.apps -array-add -string com.apple.mail
fi

defaults write com.apple.mail NSUserKeyEquivalents -dict-add 'Save As...' -string '$@s'
defaults write com.apple.mail NSUserKeyEquivalents -dict-add 'Send' -string '$@s'

# MindNode

# Add MindNode to the list of apps accepting keyboard shortcuts
if ! defaults read com.apple.universalaccess com.apple.custommenu.apps | grep -i --silent com.ideasoncanvas.mindnode.macos; then
    defaults write com.apple.universalaccess com.apple.custommenu.apps -array-add -string com.ideasoncanvas.mindnode.macos
fi

defaults write com.ideasoncanvas.mindnode.macos NSUserKeyEquivalents -dict-add 'Zoom to Selection' -string '@2'
defaults write com.ideasoncanvas.mindnode.macos NSUserKeyEquivalents -dict-add 'Zoom In' -string '@='
defaults write com.ideasoncanvas.mindnode.macos NSUserKeyEquivalents -dict-add 'Zoom to Fit' -string '@1'
defaults write com.ideasoncanvas.mindnode.macos NSUserKeyEquivalents -dict-add 'Zoom Out' -string '@-'

# iTerm

# Add iTerm to the list of apps accepting keyboard shortcuts
if ! defaults read com.apple.universalaccess com.apple.custommenu.apps | grep -i --silent com.googlecode.iterm2; then
    defaults write com.apple.universalaccess com.apple.custommenu.apps -array-add -string com.googlecode.iterm2
fi

defaults write com.googlecode.iterm2 NSUserKeyEquivalents -dict-add "\033Shell\033Split Horizontally with Current Profile" -string '@^d'

###############################################################################
# Divvy                                                                       #
###############################################################################

defaults write com.mizage.Divvy defaultRowCount -int 4
defaults write com.mizage.Divvy defaultColumnCount -int 10
defaults write com.mizage.Divvy enableAnimations -bool false
defaults write com.mizage.Divvy globalHotkey -dict keyCode -int 2 modifiers -int 768
defaults write com.mizage.Divvy showMenuIcon -bool false
defaults write com.mizage.Divvy showResizePreview -bool false
defaults write com.mizage.Divvy useDefaultGrid -bool true
defaults write com.mizage.Divvy useGlobalHotkey -bool true

###############################################################################
# Pomodoro                                                                    #
###############################################################################

defaults write com.ugolandini.Pomodoro longbreakEnabled -bool false
defaults write com.ugolandini.Pomodoro tickAtBreakEnabled -bool false
defaults write com.ugolandini.Pomodoro tickEnabled -bool false
defaults write com.ugolandini.Pomodoro speechAtStartEnabled -bool false
defaults write com.ugolandini.Pomodoro speechAtBreakFinishedEnabled -bool false
defaults write com.ugolandini.Pomodoro speechAtEndEnabled -bool false
defaults write com.ugolandini.Pomodoro initialTime -int 23
defaults write com.ugolandini.Pomodoro ringVolume -float 20.0
defaults write com.ugolandini.Pomodoro ringBreakVolume -float 20.0
defaults write com.ugolandini.Pomodoro pomodoroName -string "Enter Pomodoro name"
defaults write com.ugolandini.Pomodoro showSplashScreenAtStartup -bool false
defaults write com.ugolandini.Pomodoro globalStartDate -date 2017-02-14T12:00:00Z
# defaults write com.ugolandini.Pomodoro globalPomodoroStarted -int 9803
# defaults write com.ugolandini.Pomodoro globalPomodoroDone -int 9391
# defaults write com.ugolandini.Pomodoro globalPomodoroReset -int 363
# defaults write com.ugolandini.Pomodoro globalInternalInterruptions -int 88
# defaults write com.ugolandini.Pomodoro globalExternalInterruptions -int 19
# defaults write com.ugolandini.Pomodoro globalPomodoroResumed -int 96

###############################################################################
# Notational Velocity                                                         #
###############################################################################

defaults write net.notational.velocity CheckSpellingInNoteBody -bool false
defaults write net.notational.velocity UseSoftTabs -bool true
# defaults delete net.notational.velocity Bookmarks
# /usr/libexec/PlistBuddy -c "Add :Bookmarks array" ~/Library/Preferences/net.notational.velocity.plist
# /usr/libexec/PlistBuddy -c "Add :Bookmarks:0 dict" ~/Library/Preferences/net.notational.velocity.plist
# /usr/libexec/PlistBuddy -c "Add :Bookmarks:0:NoteUUIDString string 'F73432D4-B342-4943-B875-F1F1004DB883'" ~/Library/Preferences/net.notational.velocity.plist
# /usr/libexec/PlistBuddy -c "Add :Bookmarks:0 dict" ~/Library/Preferences/net.notational.velocity.plist
# /usr/libexec/PlistBuddy -c "Add :Bookmarks:0:NoteUUIDString string '0918ABB4-7AAE-4200-84E0-00934F9AAFB4'" ~/Library/Preferences/net.notational.velocity.plist
# /usr/libexec/PlistBuddy -c "Add :Bookmarks:0 dict" ~/Library/Preferences/net.notational.velocity.plist
# /usr/libexec/PlistBuddy -c "Add :Bookmarks:0:NoteUUIDString string '533A9111-E686-492C-999B-42B6C25C0A26'" ~/Library/Preferences/net.notational.velocity.plist
# /usr/libexec/PlistBuddy -c "Add :Bookmarks:0 dict" ~/Library/Preferences/net.notational.velocity.plist
# /usr/libexec/PlistBuddy -c "Add :Bookmarks:0:NoteUUIDString string '5EE34910-BE5D-4A38-810F-7672F03E69B3'" ~/Library/Preferences/net.notational.velocity.plist
# /usr/libexec/PlistBuddy -c "Add :Bookmarks:0 dict" ~/Library/Preferences/net.notational.velocity.plist
# /usr/libexec/PlistBuddy -c "Add :Bookmarks:0:NoteUUIDString string '3A9FE800-6514-4E75-974B-16097192CE03'" ~/Library/Preferences/net.notational.velocity.plist
# /usr/libexec/PlistBuddy -c "Add :Bookmarks:0 dict" ~/Library/Preferences/net.notational.velocity.plist
# /usr/libexec/PlistBuddy -c "Add :Bookmarks:0:NoteUUIDString string '8F28B3DE-5840-4F4E-B085-24D27E84A3ED'" ~/Library/Preferences/net.notational.velocity.plist
# /usr/libexec/PlistBuddy -c "Add :Bookmarks:0 dict" ~/Library/Preferences/net.notational.velocity.plist
# /usr/libexec/PlistBuddy -c "Add :Bookmarks:0:NoteUUIDString string 'D8E8305D-2E41-4785-8008-1FB4F228521F'" ~/Library/Preferences/net.notational.velocity.plist
# /usr/libexec/PlistBuddy -c "Add :Bookmarks:0 dict" ~/Library/Preferences/net.notational.velocity.plist
# /usr/libexec/PlistBuddy -c "Add :Bookmarks:0:NoteUUIDString string 'FCFD947B-F6EB-446B-8530-A52B84421CE3'" ~/Library/Preferences/net.notational.velocity.plist
# /usr/libexec/PlistBuddy -c "Add :Bookmarks:0 dict" ~/Library/Preferences/net.notational.velocity.plist
# /usr/libexec/PlistBuddy -c "Add :Bookmarks:0:NoteUUIDString string 'CFB5FD96-06B6-4A0D-933B-09D76359C544'" ~/Library/Preferences/net.notational.velocity.plist

###############################################################################
# Things                                                                      #
###############################################################################

# Things is a sandboxed app
# Just like with Safari, the process executing these commands will need Full Disk Access to circumvent Apple’s System Integrity Protocol
# If you already granted permissions for Safari above, this shouldn’t need any additional work
# If you’re copying and pasting this code, look at the handling of permissions with Safari

# Don’t show the onboarding
defaults write com.culturedcode.ThingsMac OnboardingDidComplete -bool true
# Show Calendar Events in Today and Upcoming lists
defaults write com.culturedcode.ThingsMac AppleEventsEnabled -bool true
# Disable the quick todo entry shortcut
defaults write com.culturedcode.ThingsMac QuickEntryEnabled -bool false
# Hide the Dock badge
defaults write com.culturedcode.ThingsMac CCDockCountType -int 0

###############################################################################
# iTerm 2                                                                     #
###############################################################################

defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/.dotfiles/iterm2"
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile -bool true
defaults write com.googlecode.iterm2 "NoSyncNeverRemindPrefsChangesLostForFile_selection" -int 2

###############################################################################
# Finish Setup                                                                #
###############################################################################

# Finish macOS Setup
killall Finder
killall Dock
killall Safari
echo "\n<<< macOS Setup Complete.
    A logout or restart might be necessary. >>>\n"


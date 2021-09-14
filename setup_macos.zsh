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

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

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
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Reduce the spring loading delay for directories (11.5.2 default: 0.5)
defaults write NSGlobalDomain com.apple.springing.delay -float 0.2

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
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock tilesize -int 50
defaults write com.apple.dock largesize -int 52
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock persistent-apps -array
# How quickly the Dock animates into view
defaults write com.apple.dock autohide-time-modifier -float 0.8
# How long it takes before the Dock animation starts
defaults write com.apple.dock autohide-delay -float 0.0

###############################################################################
# Other                                                                       #
###############################################################################

# Third-Party Software

# iTerm2 Settings
# defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
# defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/.dotfiles/iterm2"
# defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile -bool true


# Finish macOS Setup
killall Finder
killall Dock
echo "\n<<< macOS Setup Complete.
    A logout or restart might be necessary. >>>\n"


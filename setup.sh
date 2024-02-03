#! /bin/zsh

# This setup script was forked from @mdo (https://github.com/mdo/config) and then customized by @funkybunch.
# Credit to https://github.com/mathiasbynens/dotfiles for macOS customization

# This fork is configured to use ZSH on Apple Silicon

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#
# Color key
#
red=$'\e[1;31m'
green=$'\e[1;32m'
yellow=$'\e[1;33m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
end=$'\e[0m'

#
# Prep
#
homebrew_pkgs_dir="/opt/homebrew/Cellar/"
homebrew_casks_dir="/opt/homebrew/Caskroom/"
github_dir="$HOME/GitHub/"

printf "%s\n======================================================================\n%s" $yellow $end
printf "%s# Loading funkybunch/setup\n%s" $yellow $end
printf "%s======================================================================\n%s" $yellow $end


#
# Install Xcode
#
printf "%s\n# Installing Xcode tools...\n%s" $yellow $end
xcode-select --install

#
# Copying dotfiles
#
# printf "%s\n# Copying dotfiles...\n%s" $yellow $end

# dotfiles=( bash_profile zshenv npmrc gitconfig )
# for file in "${dotfiles[@]}"
# do
#   printf "%s  - .$file%s"
#   if [[ ! -e "$HOME/.$file" ]]; then
#     {
#       curl https://raw.githubusercontent.com/funkybunch/setup/master/.$file > $HOME/.$file
#     } &> /dev/null
#     printf "%s - Success!\n%s" $green $end
#   else
#     printf "%s - Already present\n%s" $cyan $end
#   fi
# done

#
# Creating directories
#
printf "%s\n# Creating directories...\n%s" $yellow $end
directories=( GitHub Configs Utils '.nvm' )
for directory in "${directories[@]}"
do
  printf "%s  - Creating $directory...%s"
  if [[ ! -e "$HOME/$directory" ]]; then
    mkdir $HOME/$directory
    printf "%s\t- Success!\n%s" $green $end
  else
    printf "%s\t- Already created\n%s" $cyan $end
  fi
done

#
# Cloning repos
#
# printf "%s\n# Cloning repositories...\n%s" $yellow $end

# cd $github_dir
# github_repos=( design brand icons thehub )
# for repo in "${github_repos[@]}"
# do
#   printf "%s  - GitHub/$repo%s"
#   if [[ ! -e "$github_dir/$repo" ]]; then
#     {
#       git clone https://github.com/github/$repo/ $github_dir/$repo/
#     } &> /dev/null
#     printf "%s - Success!\n%s" $green $end
#   else
#     printf "%s - Already cloned\n%s" $cyan $end
#   fi
# done

#
# macOS preferences
#
printf "%s\n# Adjusting macOS...\n%s" $yellow $end
{
  # Dock
  #
  # System Preferences > Dock > Automatically hide and show the Dock:
  defaults write com.apple.dock autohide -bool true
  # System Preferences > Dock > Magnification:
  defaults write com.apple.dock magnification -bool false
  # System Preferences > Dock > Size:
  defaults write com.apple.dock tilesize -int 80
  # System Preferences > Mission Control > Automatically rearrange Spaces based on most recent use
  defaults write com.apple.dock mru-spaces -bool true
  # Clear out the dock of default icons
  defaults delete com.apple.dock persistent-apps
  defaults delete com.apple.dock persistent-others
  # Don’t show recent applications in Dock
  defaults write com.apple.dock show-recents -bool false

  # Finder
  #
  # Hide desktop icons
  defaults write com.apple.finder CreateDesktop false
  # View as columns
  defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
  # Show path bar
  defaults write com.apple.finder ShowPathbar -bool true
  # Finder: show status bar
  defaults write com.apple.finder ShowStatusBar -bool true
  # Set sidebar icon size to small
  defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2
  # When performing a search, search the current folder by default
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
  # Prevent .DS_Store files
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  # Set Desktop as the default location for new Finder windows
  # For other paths, use `PfLo` and `file:///full/path/here/`
  defaults write com.apple.finder NewWindowTarget -string "PfDe"
  defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

  # Save & Print
  #
  # Expand save and print modals by default
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

  # Set a custom wallpaper image. `DefaultDesktop.jpg` is already a symlink, and
  # all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
  #rm -rf ~/Library/Application Support/Dock/desktoppicture.db
  #sudo rm -rf /System/Library/CoreServices/DefaultDesktop.jpg
  #sudo ln -s /path/to/your/image /System/Library/CoreServices/DefaultDesktop.jpg

  # System Preferences
  #
  # Disable LCD font smoothing (default 4)
  defaults -currentHost write -globalDomain AppleFontSmoothing -int 0
  # Hot corner: Top left, put display to sleep
  # Learn how this works and how to customize hotcorners: https://apple.stackexchange.com/questions/300696/toggle-hot-corners-with-a-script
  defaults write com.apple.dock wvous-tl-corner -int 10
  defaults write com.apple.dock wvous-tl-modifier -int 0
  # Require password immediately after sleep or screen saver begins
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 30
  # Enable tap to click for trackpad
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  # Disable Dashboard
  defaults write com.apple.dashboard mcx-disabled -bool true
  # Don’t show Dashboard as a Space
  defaults write com.apple.dock dashboard-in-overlay -bool true
  # Show battery percentage in menu bar
  defaults write com.apple.menuextra.battery ShowPercent -string "YES"

  # Restart Finder and Dock (though many changes need a restart/relog)
  killall Finder
  killall Dock

} &> /dev/null
printf "%s  Done!\n%s" $green $end

#
# Additional dependencies
#

printf "%s\n# Installing additional dependencies...\n%s" $yellow $end

printf "%s\n  Homebrew:\n%s" $yellow $end

if [[ ! -e "/usr/local/bin/brew" ]]; then
  {
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  } &> /dev/null
  printf "%s  - Done!\n%s" $green $end
else
  printf "%s  - Already installed\n%s" $cyan $end
fi

# Enable Homebrew automatic updates
brew tap homebrew/autoupdate
installed_packages=$(brew list)
installed_casks=$(brew list --cask)

# Install homebrew packages
printf "%s\n  Installing Homebrew packages...\n%s" $yellow $end
packages=( wget ffmpeg coreutils webp nvm 'python@3.12' )
for package in "${packages[@]}"
do
  printf "%s  - Install $package%s"
  if [[ ! -e "$homebrew_pkgs_dir/$package" ]]; then
    {
      brew install $package
    } &> /dev/null
    printf "%s  \t- Installed!\n%s" $green $end
  else
    printf "%s  \t- Already installed\n%s" $cyan $end
  fi
done

# Install homebrew casks
printf "%s\n  Installing Homebrew casks...\n%s" $yellow $end
casks=( vlc signal bitwarden github brave-browser visual-studio-code blender betterdisplay \
  bartender adobe-creative-cloud discord docker fantastical home-assistant jellyfin webstorm \
  nextcloud slack figma pycharm-ce spotify steam balenaetcher 'qfinder-pro' 'sweet-home3d' via vial zoom displaylink )
for cask in "${casks[@]}"
do
  printf "%s  - Install $cask%s"
  if [[ ! -e "$homebrew_casks_dir/$cask" ]]; then
    {
      brew install --cask $cask
    } &> /dev/null
    printf "%s  \t- Installed!\n%s" $green $end
  else
    printf "%s  \t- Already installed\n%s" $cyan $end
  fi
done

# Add nvm to Terminal Session
printf "%s\n  Adding NVM to terminal session...\n%s" $yellow $end
source ~/.nvm/nvm.sh

#
# Install NodeJS
#
printf "%s\n# Installing Node.js...\n%s" $yellow $end
node_versions=( 14 16 18 )
for node_version in "${node_versions[@]}"
do
  printf "%s  - Installing Node.js version $node_version%s"
  nvm install $node_version
done
nvm use 18
nvm alias default 18
printf "%s  Configuring nvm to use latest long-term support version%s"

#
# Add apps back to dock
#
printf "%s\n  Adding apps to dock...\n%s" $yellow $end
docked=('/Applications/Qfinder Pro.app' '/Applications/Fantastical.app' '/System/Applications/Mail.app' '/System/Applications/Messages.app' \
        '/Applications/Brave Browser.app' '/Applications/Discord.app' '/Applications/WebStorm.app' '/Applications/GitHub Desktop.app' '/System/Applications/Utilities/Terminal.app' \
        '/Applications/Bitwarden.app')

for app in "${docked[@]}"
do
  printf "%s  - Docking $app\n%s"
  defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
done

killall Dock

#
# All done!
#
printf "%s\nWoohoo, all done!\n%s" $green $end

echo 'Hello from .zshrc'

# Set Variables
# Syntax highlighting for man pages using bat
export BAT_THEME="GitHub"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export NULLCMD=bat
export HOMEBREW_BUNDLE_FILE="$DOTFILES/Brewfile"

# Change ZSH Options


# Create Aliases
alias ls='exa -laFh --git'
alias exa='exa -laFh --git'
alias trail='<<<${(F)path}'
alias rm=trash
alias defaults-domains='defaults domains | tr , \\n'
alias bbd="brew bundle dump --force --describe"

# Customize Prompt(s)
PROMPT='
%1~ %L %# '

RPROMPT='%*'

# Add Homebrew to PATH
# https://docs.brew.sh/Manpage#shellenv
OS="$(uname)"
UNAME_MACHINE="$(/usr/bin/uname -m)"
if [[ "${OS}" == "Darwin" && "${UNAME_MACHINE}" == "arm64" ]]
then
  echo 'OH HI'
  # Prepend Homebrew’s bin and sbin directories to PATH
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Add Locations to $path Array
typeset -U path

path=(
  "$N_PREFIX/bin"
  $path
)

# Write Handy Functions
function mkcd() {
  mkdir -p "$@" && cd "$_";
}


# Use ZSH Plugins


# ...and Other Surprises

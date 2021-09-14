echo 'Hello from .zshrc'

# Set Variables
# Syntax highlighting for man pages using bat
export BAT_THEME="GitHub"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export NULLCMD=bat


# Change ZSH Options


# Create Aliases
alias ls='exa -laFh --git'
alias exa='exa -laFh --git'
alias trail='<<<${(F)path}'
alias rm=trash
alias defaults-domains='defaults domains | tr , \\n'

# Customize Prompt(s)
PROMPT='
%1~ %L %# '

RPROMPT='%*'


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

# Call bbd from any directory; DOTFILES is set in zshenv
function bbd() {
  zsh -c "cd $DOTFILES; brew bundle dump --force --describe" 
}


# Use ZSH Plugins


# ...and Other Surprises

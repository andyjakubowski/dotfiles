echo 'Hello AGAIN from .zshrc'

# Set Variables

export BAT_THEME="GitHub"

# Syntax highlighting for man pages using bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export NULLCMD=bat
export N_PREFIX="$HOME/.n"

# Change ZSH Options

# Create Aliases

alias ls='ls -lAFh'
alias exa='exa -laFh --git'
alias trail='<<<${(F)path}'

# Customize Prompt(s)
PROMPT='
%1~ %L %# '

RPROMPT='%*'

# Add Locations to $PATH Variable

export PATH="$PATH:$N_PREFIX/bin"

# Write Handy Functions

function mkcd() {
  mkdir -p "$@" && cd "$_"
}

# Use ZSH Plugins

# ...and Other Surprises

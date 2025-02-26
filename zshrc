echo 'Hello from .zshrc'

# Set Variables
# Syntax highlighting for man pages using bat
export BAT_THEME="GitHub"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export NULLCMD=bat
export HOMEBREW_BUNDLE_FILE="$DOTFILES/Brewfile"

# Customize Prompt(s)
PROMPT='
%1~ %L %# '

RPROMPT='%*'

# Add Homebrew to PATH
# https://docs.brew.sh/Manpage#shellenv
OS="$(uname)"
UNAME_MACHINE="$(/usr/bin/uname -m)"
if [[ "${OS}" == "Darwin" && "${UNAME_MACHINE}" == "arm64" ]]; then
  # Prepend Homebrew’s bin and sbin directories to PATH
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Add Locations to $path Array
typeset -U path

path=(
  # Homebrew Ruby is keg-only and not symlinked; You need to manually put it on the PATH if you want to use it
  # Normally, you should use rbenv for installing different Ruby versions; This is here because my ruby-build kept failing on an M1 Mac
  # /opt/homebrew/opt/ruby@2.7/bin
  # /opt/homebrew/lib/ruby/gems/2.7.0/bin
  "$N_PREFIX/bin"
  $path
)

# Write Handy Functions
function mkcd() {
  mkdir -p "$@" && cd "$_"
}

# Set up pyenv (Python version manager)
# Set env environment variable for pyenv root directory
export PYENV_ROOT="$HOME/.pyenv"
# Add pyenv to PATH if it’s not already there
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
# Set up shims and autocompletion
eval "$(pyenv init -)"

# Prepend asdf to PATH
# asdf is a version manager for Node, Ruby, and other languages
# https://asdf-vm.com/guide/getting-started.html
# . $(brew --prefix asdf)/libexec/asdf.sh

# Create Aliases
alias ls='exa -laFh --git'
alias exa='exa -laFh --git'
alias trail='<<<${(F)path}'
alias rm=trash
alias defaults-domains='defaults domains | tr , \\n'
alias bbd="brew bundle dump --force --describe"
# Aliases for keg-only Ruby 2.x
RUBY_PATH=$(brew --prefix ruby)@2/bin
alias bbundle=$RUBY_PATH/bundle
alias bexec='bbundle exec'
alias brails='bexec rails'
alias berb=$RUBY_PATH/erb
alias bgem=$RUBY_PATH/gem
alias birb=$RUBY_PATH/irb
alias brake=$RUBY_PATH/rake
alias bruby=$RUBY_PATH/ruby
# Output PATH segments on separate lines
alias path='echo $path | tr " " \\n'

# Use ZSH Plugins

# ...and Other Surprises

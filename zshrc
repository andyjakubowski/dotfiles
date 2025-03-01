echo 'Hello from .zshrc'

# Set Variables
# Syntax highlighting for man pages using bat
export BAT_THEME="GitHub"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export NULLCMD=bat
export HOMEBREW_BUNDLE_FILE="$DOTFILES/Brewfile"

# Customize Prompt(s)
ORIGINAL_PROMPT_LINE_1='
'
ORIGINAL_PROMPT_LINE_2="%1~ %L %# " # Restore complete prompt variable
ORIGINAL_PROMPT="${ORIGINAL_PROMPT_LINE_1}${ORIGINAL_PROMPT_LINE_2}"
PROMPT="${ORIGINAL_PROMPT}"

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

# Activate Python venv when entering a directory containing a ".venv" subdirectory
activate_venv_if_available() {
  local venv_dir=".venv"
  if [[ -d "$PWD/$venv_dir" ]]; then
    echo "Detected .venv directory; Activating virtual environment..."

    # Disable default venv prompt formatting
    export VIRTUAL_ENV_DISABLE_PROMPT=1

    # Source the venv
    source "$PWD/$venv_dir/bin/activate"

    # Customize prompt with venv name (only if not already present)
    # VIRTUAL_VENV is set by the venv activate script
    export VENV_NAME="(${VIRTUAL_ENV:t})"

    PROMPT="${ORIGINAL_PROMPT_LINE_1}${VENV_NAME} ${ORIGINAL_PROMPT_LINE_2}"
  else
    deactivate 2>/dev/null # Suppress errors if no venv is active
    PROMPT="${ORIGINAL_PROMPT}"
    unset VENV_NAME
  fi
}

autoload -U add-zsh-hook

# Run function when changing directories
add-zsh-hook chpwd activate_venv_if_available
# Run function when starting a new shell
activate_venv_if_available

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

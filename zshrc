echo 'Hello from .zshrc'

# Set Variables
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

# Create Aliases
alias ls='eza -lah --classify --git'
alias eza='eza -lah --classify --git'
alias trail='<<<${(F)path}'
alias rm=trash
alias defaults-domains='defaults domains | tr , \\n'
alias bbd="brew bundle dump --force --describe"

# Output PATH segments on separate lines
alias path='echo $path | tr " " \\n'

# Set up GitHub Copilot suggest (ghcs) and explain (ghce) aliases
# This gives suggest permission to execute suggested commands
eval "$(gh copilot alias -- zsh)"

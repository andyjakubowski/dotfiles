export DOTFILES="$HOME/.dotfiles"
export HOMEBREW_CASK_OPTS="--no-quarantine"
export N_PREFIX="$HOME/.n"
export SUDO_PROMPT="Superuser (sudo) Password: "

function exists() {
  # `command -v` is similar to `which`
  # https://stackoverflow.com/a/677212/1341838
  command -v $1 1>/dev/null 2>&1

  # More explicitly written:
  # command -v $1 1>/dev/null 2>/dev/null
}

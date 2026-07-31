echo 'Hello from .zshrc'

# Set Variables
export HOMEBREW_BUNDLE_FILE="$DOTFILES/Brewfile"
export HOMEBREW_BUNDLE_DUMP_DESCRIBE=true

# Deepnote-specific variables
# export ESLINT_TYPECHECK_ENABLED=true

# Load environment variables from ~/.env if it exists
if [ -f "$HOME/.env" ]; then
  export $(grep -v '^#' "$HOME/.env" | xargs)
fi

# Node setup
# --max-old-space-size sets max heap memory in MB (adjust as needed for your machine)
export NODE_OPTIONS="--max-old-space-size=16384"

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
  # Used by tools like pipx, poetry
  "$HOME/.local/bin"
  $path
)

# Write Handy Functions
function mkcd() {
  mkdir -p "$@" && cd "$_"
}

function digitalocean_api() {
  local method="$1"
  local route="$2"
  local data="$3"
  local -a args

  args=(
    --silent
    --show-error
    --fail-with-body
    --request "$method"
    --header "Authorization: Bearer $(op read 'op://Personal/digital-ocean-droplet-token/credential')"
    --header 'Content-Type: application/json'
  )
  [[ -n "$data" ]] && args+=(--data "$data")

  curl "${args[@]}" "https://api.digitalocean.com$route"
}

function _droplet_list() {
  digitalocean_api GET '/v2/droplets?per_page=200' | jq -r '
    [
      ["ID", "NAME", "STATUS", "PUBLIC IPV4", "TAGS"],
      (.droplets[] | [
        (.id | tostring),
        .name,
        .status,
        ([.networks.v4[]? | select(.type == "public") | .ip_address][0] // "-"),
        ((.tags // []) | if length == 0 then "-" else join(",") end)
      ])
    ] as $rows
    | ($rows | transpose | map(map(length) | max)) as $widths
    | $rows[]
    | to_entries
    | map(
        if .key == 4 then .value
        else .value + (" " * ($widths[.key] - (.value | length) + 2))
        end
      )
    | join("")
  '
}

function _droplet_create() {
  local ssh_key_id payload droplet_id droplet_status public_ip response
  local ssh_key_name="mbp-work"
  local region="fra1"
  local size="s-1vcpu-512mb-10gb"
  local image="ubuntu-26-04-x64"
  local tag="${1:-sandbox}"

  ssh_key_id="$(digitalocean_api GET '/v2/account/keys?per_page=200' |
    jq -er --arg name "$ssh_key_name" '[.ssh_keys[] | select(.name == $name) | .id][0]')" || {
      echo "DigitalOcean SSH key not found: $ssh_key_name" >&2
      return 1
    }

  payload="$(jq -cn \
    --arg name "sandbox" \
    --arg region "$region" \
    --arg size "$size" \
    --arg image "$image" \
    --arg tag "$tag" \
    --argjson ssh_key_id "$ssh_key_id" \
    '{name: $name, region: $region, size: $size, image: $image, ssh_keys: [$ssh_key_id], tags: [$tag]}')"

  droplet_id="$(digitalocean_api POST '/v2/droplets' "$payload" | jq -er '.droplet.id')" || {
    echo 'Could not create the DigitalOcean sandbox.' >&2
    return 1
  }

  echo "Waiting for droplet $droplet_id..." >&2
  while true; do
    response="$(digitalocean_api GET "/v2/droplets/$droplet_id")" || return
    droplet_status="$(jq -r '.droplet.status' <<< "$response")"
    public_ip="$(jq -r '[.droplet.networks.v4[]? | select(.type == "public") | .ip_address][0] // empty' <<< "$response")"

    if [[ "$droplet_status" == active && -n "$public_ip" ]]; then
      echo "ssh root@$public_ip"
      return
    fi

    sleep 5
  done
}

function _droplet_delete() {
  local tag="${1:-sandbox}"

  digitalocean_api DELETE "/v2/droplets?tag_name=$tag" >/dev/null &&
    echo "Deleted DigitalOcean droplets tagged $tag."
}

function droplet() {
  case "$1" in
    list) _droplet_list ;;
    create) _droplet_create "$2" ;;
    delete) _droplet_delete "$2" ;;
    *) echo 'Usage: droplet {list|create [tag]|delete [tag]}' >&2; return 1 ;;
  esac
}

# Activate Python venv when entering a directory containing a ".venv" subdirectory
activate_venv_if_available() {
  local venv_dir=".venv"
  if [[ -d "$PWD/$venv_dir" ]]; then
    echo "zsh chpwd hook: Detected a Python virtual environment directory (.venv). Activating the virtual environment by running “source .venv/bin/activate”."

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

# pnpm
export PNPM_HOME="/Users/work/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

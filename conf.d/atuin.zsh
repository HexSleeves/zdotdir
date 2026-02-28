#!/bin/zsh
#
# atuin.zsh - Atuin shell history configuration
#

[[ -o interactive ]] || return

# Initialize atuin if available
if command -v atuin &>/dev/null; then
  # Initialize atuin
  eval "$(atuin init zsh)"

  # Bind Ctrl+R to atuin search (override default history search)
  bindkey '^r' atuin-search

  # Optional: bind up arrow to atuin search (comment out if you prefer default behavior)
  # bindkey '^[[A' atuin-up-search
  # bindkey '^[OA' atuin-up-search

  # Aliases for atuin commands
  alias history='atuin history'
  alias hs='atuin search'
  alias hstats='atuin stats'

  # Quick import of existing history (run once)
  if [[ ! -f $HOME/.local/share/atuin/history.db ]]; then
    print -P "%F{yellow}Atuin history database not found. Run 'atuin import auto' to import existing history.%f"
  fi
fi

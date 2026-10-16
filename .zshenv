#!/usr/bin/env zsh
#
# .zshenv: Zsh environment file, loaded always.
#

export ZDOTDIR=${ZDOTDIR:-$HOME/.config/zsh}

# XDG
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}

# nix-darwin's /etc/zshrc runs promptinit and a second, uncached compinit (with
# compaudit) before ours, about 40ms per shell. Everything it sets is redone
# here, so skip it. Not exported: each zsh reads this file anyway.
NOSYSZSHRC=1

if [[ ! -o LOGIN ]] && [[ -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

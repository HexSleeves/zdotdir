#!/usr/bin/env zsh

typeset -gUa path fpath prepath cdpath

# XDG
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_PROJECTS_DIR=${XDG_PROJECTS_DIR:-$HOME/Projects}

# Apps
export EDITOR=nvim
export VISUAL=code
export PAGER=less
export SHELL_SESSIONS_DISABLE=1

# Set the path elements that should always be first.
#
# ~/.local/bin MUST precede /opt/homebrew/bin. Two different tools ship as
# `kubelogin`: Azure's (AAD flags, what deploy-doctor and kubeconfig exec
# stanzas call) and int128/kubelogin (generic OIDC) from Homebrew. The shim at
# ~/.local/bin/kubelogin routes the bare name to Azure's; with Homebrew first,
# int128's wins instead and every AAD flag fails as `unknown flag: --login`.
#
# This mirrors the shared PATH contract in ~/.config/shell/path.sh. That file
# is sourced from ~/.zshenv, but login shells read .zprofile *afterwards*, so
# this prepath is the last word on the brew-vs-~/.local/bin question.
prepath=(
  $HOME/bin(N)
  $HOME/.local/bin(N)
  /opt/homebrew/bin(N)
)
path=( $prepath $path )

# Set the list of directories that cd searches.
cdpath=(
  $XDG_PROJECTS_DIR(N/)
  $XDG_PROJECTS_DIR/mattmc3(N/)
  $cdpath
)

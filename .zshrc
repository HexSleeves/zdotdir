#!/usr/bin/env zsh
#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

# Profiling
[[ "$ZPROFRC" -ne 1 ]] || zmodload zsh/zprof
alias zprofrc="ZPROFRC=1 zsh"

# Set the styles
[[ -r $ZDOTDIR/.zstyles ]] \
 && . $ZDOTDIR/.zstyles

# Create an amazing Zsh config using antidote plugins.
fpath+=($ZDOTDIR/functions $fpath)
autoload -Uz is-macos is-warp is-not-warp is-ps1-visible

# Define cached-eval if it doesn't exist
if ! typeset -f cached-eval >/dev/null 2>&1; then
  cached-eval() {
    local cmd="$1"; shift
    eval "$("$cmd" "$@")"
  }
fi
zsh_theme=(starship zephyr)
source $ZDOTDIR/lib/antidote-edge.zsh

# Never start in the root file system.
[[ "$PWD" != "/" ]] || cd

# we skip these for z1
source $ZDOTDIR/lib/compinit.zsh
source $ZDOTDIR/lib/confd.zsh

# Local settings
[[ -r $HOME/.local/config/zsh/.zshrc.local ]] \
 && . $HOME/.local/config/zsh/.zshrc.local

# Run the end of zshrc hook manually (defined in Z1)
(( $+functions[run_post_zshrc] )) && run_post_zshrc

# A sourced file's .zwc skips parsing it. zsh ignores a .zwc older than its
# source, so only stale ones get rebuilt, in the background. umask 077: the
# *.local.zsh files hold secrets, and their .zwc must not be world-readable.
() {
  local f
  local -a stale
  for f in $ZDOTDIR/{.zshenv,.zprofile,.zshrc,.zstyles} \
           $ZDOTDIR/{lib,conf.d}/*.zsh(N.) $ZSH_CACHE_DIR/cached-eval/*.zsh(N.); do
    [[ $f.zwc -nt $f ]] || stale+=($f)
  done
  (( $#stale )) || return
  {
    umask 077
    autoload -Uz zrecompile
    for f in $stale; do zrecompile -pq -R $f; done
  } &!
}

# Finish profiling by calling zprof.
[[ "$ZPROFRC" -eq 1 ]] && zprof
[[ -v ZPROFRC ]] && unset ZPROFRC

# Warpify subshells (docker exec, nested zsh); must run after everything else.
is-warp && printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh"}}\x9c'

# Always return success
true

#!/bin/zsh
#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

export ZSH_ENABLE_NVM=0

# Profiling
[[ "$ZPROFRC" -ne 1 ]] || zmodload zsh/zprof
alias zprofrc="ZPROFRC=1 zsh"

# Set Zsh location vars.
ZSH_CONFIG_DIR="${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}"
ZSH_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p $ZSH_CONFIG_DIR $ZSH_DATA_DIR $ZSH_CACHE_DIR

# Set essential options
setopt EXTENDED_GLOB INTERACTIVE_COMMENTS

# Add custom completions
fpath=($ZSH_CONFIG_DIR/completions $fpath)

# Lazy-load (autoload) Zsh function files from a directory.
for _fndir in $ZSH_CONFIG_DIR/functions(/FN) $ZSH_CONFIG_DIR/functions/*(/FN); do
  fpath=($_fndir $fpath)
  autoload -Uz $_fndir/*~*/_*(N.:t)
done
unset _fndir

# Set any zstyles you might use for configuration.
[[ -r $ZSH_CONFIG_DIR/.zstyles ]] && source $ZSH_CONFIG_DIR/.zstyles

# Create an amazing Zsh config using antidote plugins.
source $ZSH_CONFIG_DIR/lib/antidote.zsh

IGNORE_LIST=(
  dotnet.zsh
  jupyter.zsh
  nim.zsh
  nvm.zsh
)

# Source conf.d.
for _rc in $ZDOTDIR/conf.d/*.zsh; do
  # ignore files that begin with ~
  [[ "${_rc:t}" != '~'* ]] || continue
  [[ "${IGNORE_LIST[(I)${_rc:t}]}" -eq 0 ]] || continue
  source "$_rc"
done
unset _rc

# Never start in the root file system.
[[ "$PWD" != "/" ]] || cd

# Finish profiling by calling zprof.
[[ "$ZPROFRC" -eq 1 ]] && zprof
[[ -v ZPROFRC ]] && unset ZPROFRC

. "$HOME/.local/share/../bin/env"

# Always return success
true



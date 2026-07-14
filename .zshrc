#!/bin/zsh
#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

# Profiling
[[ "$ZPROFRC" -ne 1 ]] || zmodload zsh/zprof
alias zprofrc="ZPROFRC=1 zsh"

# Enable Powerlevel10k instant prompt. Should stay close to the top of .zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Antibody compatibility shim → delegates to antidote (fast-pathed).
# `source <(antidote bundle ...)` costs ~3.4s/shell (subprocess + antidote
# boot). Resolve clone/path calls directly so startup is instant.
antibody() {
  case "${1:-}" in
    init) ;;
    bundle)
      local repo="${@:2}"
      repo="${repo%% *}"
      local repo_path="${ANTIDOTE_HOME:-${XDG_CACHE_HOME:-$HOME/.cache}/repos}/github.com/$repo"
      # kind:clone only ensures the repo is cloned — skip if already present
      [[ "$*" == *"kind:clone"* && -d "$repo_path/.git" ]] && return 0
      # Cache the load script for non-clone bundles
      local key="${(j:_:)${@:2}//[^a-zA-Z0-9._-]/_}"
      local cache="$ZSH_CACHE_DIR/antibody-bundle-$key.zsh"
      if [[ ! -s $cache ]]; then
        mkdir -p "${cache:h}"
        antidote bundle "${@:2}" >| "$cache"
      fi
      source "$cache"
      ;;
    path)
      local repo="${@:2}"
      repo="${repo%% *}"
      print -r "${ANTIDOTE_HOME:-${XDG_CACHE_HOME:-$HOME/.cache}/repos}/github.com/$repo"
      ;;
    *) antidote "$@" ;;
  esac
}
commands[antibody]=antibody

# Add Hermes tooling (uv) to PATH
export PATH="$HOME/.hermes/bin:$PATH"

# Plugins for zsh_custom
plugins=(
  azure
  clipboard
  common-aliases
  common-functions
  confd
  direnv
  dotfiles
  dotnet
  extract
  git
  git-cmds
  iwd
  jupyter
  perl
  prj
  python
  ruby
  xdg-apps
  zoxide
)

# Create an amazing Zsh config using antidote plugins.
source $ZDOTDIR/lib/antidote-fast.zsh

# ZSH_COMPDUMP=$XDG_CACHE_HOME/zsh/zcompdump
# compinit -i -d "$ZSH_COMPDUMP"

# # Set prompt
# autoload -Uz promptinit && promptinit
# setopt transient_rprompt
# prompt z1

source $ZDOTDIR/.p10k.zsh
(( ! ${+functions[p10k]} )) || p10k finalize

# Never start in the root file system.
[[ "$PWD" != "/" ]] || cd

# Local settings
[ -r $HOME/.local/config/zsh/.zshrc.local ] \
&& . $HOME/.local/config/zsh/.zshrc.local

# Finish profiling by calling zprof.
[[ "$ZPROFRC" -eq 1 ]] && zprof
[[ -v ZPROFRC ]] && unset ZPROFRC

# Always return success
true

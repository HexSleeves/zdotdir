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

# Antibody compatibility shim → resolves clone/path/bundle directly so
# startup is instant. The real autoloaded `antidote` boots the whole
# framework + spawns git on every call (~4s each); this shim short-
# circuits the calls that fire on every shell start.
#
# The real framework is bootstrapped lazily, only for genuine misses
# (non-clone bundle generation, `antidote update`, etc.).
_antidote_real() {
  (( ${+functions[antidote-dispatch]} )) || \
    builtin source "${ANTIDOTE_REPO:-$ZDOTDIR/.antidote}/antidote.zsh"
  antidote-dispatch "$@"
}
antibody() {
  case "${1:-}" in
    init) ;;  # `source <(antibody init)` → no-op; we define antidote ourselves
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
        _antidote_real bundle "${@:2}" >| "$cache"
      fi
      source "$cache"
      ;;
    path)
      local repo="${@:2}"
      repo="${repo%% *}"
      print -r "${ANTIDOTE_HOME:-${XDG_CACHE_HOME:-$HOME/.cache}/repos}/github.com/$repo"
      ;;
    *) _antidote_real "$@" ;;
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

# Route zsh_custom's vendored init/antidote.zsh through the antibody shim
# above. Without this it takes the `else` branch: sources the 61KB antidote
# framework + runs `source <(antidote init)` + spawns the framework for every
# `antidote bundle/path` call — ~4s/shell each. The antibody branch is a
# complete no-op here (commands[antibody] is already defined by the shim).
zstyle ':zsh_custom:antidote' use-antibody yes

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

#!/bin/zsh
#
# .zshenv: Zsh environment file, loaded always.
#

export ZDOTDIR=${ZDOTDIR:-$HOME/.config/zsh}

# XDG
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-$HOME/.xdg}
export XDG_PROJECTS_DIR=${XDG_PROJECTS_DIR:-$HOME/Projects}
export XDG_WORK_DIR=${XDG_WORK_DIR:-$HOME/Work}
export ZSH_CONFIG_DIR=${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}
export ZSH_DATA_DIR=${XDG_DATA_HOME:-$HOME/.local/share}/zsh
export ZSH_CACHE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
: ${__zsh_config_dir:=$ZSH_CONFIG_DIR}
: ${__zsh_user_data_dir:=$ZSH_DATA_DIR}
: ${__zsh_cache_dir:=$ZSH_CACHE_DIR}

# Ensure Zsh directories exist.
() {
  local dir
  for dir in "$@"; do
    [[ -d "$dir" ]] || mkdir -p -- "$dir"
  done
} "$ZSH_CONFIG_DIR" "$ZSH_DATA_DIR" "$ZSH_CACHE_DIR" \
  "$XDG_STATE_HOME" "$XDG_RUNTIME_DIR" "$XDG_PROJECTS_DIR" "$XDG_WORK_DIR"

# Make Terminal.app behave.
if [[ "$OSTYPE" == darwin* ]]; then
  export SHELL_SESSIONS_DISABLE=1
fi
typeset -gU PATH path

# Guarantee the core system binary directories are always on PATH. Interactive
# shells spawned by non-login parents (tmux, editor terminals, subprocesses)
# can inherit a PATH that omits /bin and /usr/bin, leaving even mkdir/rm/mv/cat
# unresolvable during startup — e.g. the cached-eval / cached-source
# cache-rebuild paths. Appended (deduped via typeset -U above), so this never
# perturbs the carefully-tuned PATH order in front of it.
path+=(/bin /usr/bin /usr/sbin /sbin)

# Nix profiles. This machine is managed by nix-darwin + home-manager, which
# install into profile dirs that nothing else adds to PATH:
#   /etc/profiles/per-user/$USER  home-manager packages (direnv, gpg, atuin, ...)
#   /run/current-system/sw        nix-darwin system profile (darwin-rebuild, ...)
# Without these, ~160 installed binaries are unreachable and the guarded conf.d
# files below silently skip their integrations (this is what broke direnv/gpg
# after the Homebrew -> nix migration). Prepended so conf.d/*.zsh — which loads
# from .zshrc, after this file — can see the tools when it probes $commands.
path=(
  /etc/profiles/per-user/${USERNAME:-$(id -un)}/bin(N)
  $HOME/.nix-profile/bin(N)
  /run/current-system/sw/bin(N)
  /nix/var/nix/profiles/default/bin(N)
  $path
)

# `brew shellenv` forks the brew binary and gets called independently by
# profile.sh, zshrc1, zsh_custom's z1.zsh, and conf.d/homebrew.zsh — cache
# its output once so the other 3 calls become instant.
# ponytail: cache never expires; `rm $ZSH_CACHE_DIR/brew-shellenv.zsh` to refresh after a brew upgrade.
if (( $+commands[brew] )); then
  brew() {
    if [[ $1 == shellenv ]]; then
      local cachefile="$ZSH_CACHE_DIR/brew-shellenv.zsh"
      [[ -s $cachefile ]] || { mkdir -p ${cachefile:h}; command brew shellenv >| $cachefile; }
      cat $cachefile
      return
    fi
    command brew "$@"
  }
fi

[ -f "$HOME/.config/shell/profile.sh" ] && . "$HOME/.config/shell/profile.sh"

# pnpm - ensure global bin dir is in PATH for non-interactive shells (e.g. topgrade)
export PNPM_HOME="/Users/lecoqjacob/.local/share/pnpm"
[[ ":$PATH:" == *":$PNPM_HOME/bin:"* ]] || export PATH="$PNPM_HOME/bin:$PATH"

# antidote home for antibody update
export ANTIDOTE_HOME="$HOME/.cache/repos"

# If running via zsh -c (command execution string), skip the rest.
# This prevents hangs when tools like Protopack spawn "zsh -c --login -i"
# and trigger heavy plugin loading (antidote, p10k, etc.).
# Keep subprocess-spawning setup BELOW this line.
[[ -z "$ZSH_EXECUTION_STRING" ]] || return 0

# Mark true interactive TTY shells so conf.d files that gate on this
# (atuin, performance, prompt, fzf-enhanced) actually load.
[[ -o interactive && -t 1 ]] && export ZSH_INTERACTIVE_TTY=1

[ -f "$HOME/.vite-plus/env" ] && . "$HOME/.vite-plus/env"
[ -f "$HOME/.local/share/cargo/env" ] && . "$HOME/.local/share/cargo/env"

#!/bin/zsh
#
# atuin.zsh - Atuin shell history configuration
#

[[ -o interactive ]] || return
(( ${ZSH_INTERACTIVE_TTY:-0} )) || return
[[ ${ZSH_BENCHMARK_MODE:-0} -eq 1 ]] && return

_atuin_init() {
  emulate -L zsh
  unset -f _atuin_init
  [[ ${ZSH_BENCHMARK_MODE:-0} -eq 1 ]] && return
  command -v atuin &>/dev/null || return

  if (( $+functions[cached-eval] )); then
    cached-eval 'atuin-init-zsh' atuin init zsh
  else
    eval "$(atuin init zsh)"
  fi

  bindkey '^r' atuin-search
  alias history='atuin history'
  alias hs='atuin search'
  alias hstats='atuin stats'

  if [[ ! -f $HOME/.local/share/atuin/history.db ]]; then
    print -P "%F{yellow}Atuin history database not found. Run 'atuin import auto' to import existing history.%f"
  fi
}

if (( $+functions[zsh-defer] )); then
  zsh-defer _atuin_init
else
  _atuin_init
fi

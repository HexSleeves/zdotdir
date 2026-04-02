[[ ${ZSH_ENABLE_FNM:-1} -eq 1 ]] || return
[[ ${ZSH_BENCHMARK_MODE:-0} -eq 1 ]] && return
(( $+commands[fnm] )) || return

_fnm_init() {
  emulate -L zsh
  unset -f _fnm_init
  eval "$(fnm env --use-on-cd --shell zsh)"
}

if (( $+functions[zsh-defer] )); then
  zsh-defer _fnm_init
else
  _fnm_init
fi

#
# peekaboo
#

[[ ${ZSH_ENABLE_PEEKABOO:-1} -eq 1 ]] || return

if (( $+commands[peekaboo] )); then
  # `peekaboo completions zsh` forks the CLI on every startup (~70ms).
  if (( $+functions[cached-source] )); then
    cached-source peekaboo-completions peekaboo completions zsh
  else
    eval "$(peekaboo completions zsh 2>/dev/null)"
  fi
fi

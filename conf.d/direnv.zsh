#
# direnv
#
# Replaces the `direnv` entry in the plugins array, which did
# `source <(direnv hook zsh)` — a fork plus process substitution on every
# startup, ~22ms in the trace. The hook output is identical between runs, so
# it is cached and byte-compiled instead.

if (( ! $+commands[direnv] )); then
  return
fi

if (( $+functions[cached-source] )); then
  cached-source direnv-hook-zsh direnv hook zsh
else
  source <(direnv hook zsh)
fi

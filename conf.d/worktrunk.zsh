#
# worktrunk: shell integration (wt function override + completions).
#
# `wt config shell init zsh` forks wt and emits ~91 lines of shell on every
# uncached startup (~22ms). cached-source byte-compiles the output so later
# shells source .zwc instead of re-forking.
#

(( $+commands[wt] )) || return 0

if (( $+functions[cached-source] )); then
  cached-source wt-shell-init command wt config shell init zsh
else
  eval "$(command wt config shell init zsh)"
fi

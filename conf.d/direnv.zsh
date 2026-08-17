#
# direnv
#
# Do not cache `direnv hook zsh`. That command embeds the absolute path of
# whichever direnv was first on PATH. After the brew → nix move, a 20h cache
# kept calling the zapped binary:
#   _direnv_hook:2: no such file or directory: /opt/homebrew/bin/direnv
#
# The hook is tiny; skip the fork. `command direnv` resolves from PATH on
# every prompt so a later store-hash or prefix change cannot leave a dead
# path in the function body.
#

if (( ! $+commands[direnv] )); then
  return
fi

_direnv_hook() {
  trap -- '' SIGINT
  eval "$(command direnv export zsh)"
  trap - SIGINT
}
typeset -ag precmd_functions
if (( ! ${precmd_functions[(I)_direnv_hook]} )); then
  precmd_functions=(_direnv_hook $precmd_functions)
fi
typeset -ag chpwd_functions
if (( ! ${chpwd_functions[(I)_direnv_hook]} )); then
  chpwd_functions=(_direnv_hook $chpwd_functions)
fi

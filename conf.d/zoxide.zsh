#
# zoxide: Configure zoxide.
#

(( $+commands[zoxide] )) || return 0

# https://github.com/ajeetdsouza/zoxide
if (( $+functions[cached-eval] )); then
  cached-eval 'zoxide-init-zsh' zoxide init zsh
else
  source <(zoxide init zsh)
fi

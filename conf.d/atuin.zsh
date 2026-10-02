#
# atuin: Shell history search.
#

(( $+commands[atuin] )) || return 1

# fzf.zsh loads after this file; an empty value stops it rebinding Ctrl-R.
export FZF_CTRL_R_COMMAND=

cached-eval atuin init zsh
bindkey '^r' atuin-search

alias history='atuin history'
alias hs='atuin search'
alias hstats='atuin stats'

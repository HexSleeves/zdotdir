#
# atuin: Shell history search.
#

(( $+commands[atuin] )) || return 1

# fzf.zsh loads after this file; an empty value stops it rebinding Ctrl-R.
export FZF_CTRL_R_COMMAND=

# The init forks `atuin uuid` (~9ms) unless a session for this SHLVL exists.
# Mint the same simple-form UUIDv7 in-process so it doesn't have to.
if [[ -z ${ATUIN_SESSION-} || ${ATUIN_SHLVL-} != $SHLVL ]]; then
  () {
    emulate -L zsh -o no_multibyte
    zmodload zsh/datetime zsh/system || return
    local raw c hex
    sysread -s 10 raw </dev/urandom || return
    for c in ${(s::)raw}; do hex+=${(l:2::0:)$(( [##16] #c ))}; done
    (( $#hex == 20 )) || return
    local ts=${(l:12::0:)$(( [##16] epochtime[1] * 1000 + epochtime[2] / 1000000 ))}
    export ATUIN_SESSION=${(L):-${ts}7${hex[1,3]}${(l:2::0:)$(( [##16] (16#${hex[4,5]} & 16#3f) | 16#80 ))}${hex[6,19]}}
    export ATUIN_SHLVL=$SHLVL
  }
fi

cached-eval atuin init zsh
bindkey '^r' atuin-search

alias history='atuin history'
alias hs='atuin search'
alias hstats='atuin stats'

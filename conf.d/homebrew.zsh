#
# homebrew: Initialize Linux Homebrew
#

[[ $OSTYPE == linux* ]] || return
[[ -n "$HOMEBREW_PREFIX" ]] && return
[[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] || return

export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
eval "$('/home/linuxbrew/.linuxbrew/bin/brew' shellenv zsh)"

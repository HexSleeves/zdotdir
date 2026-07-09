#
# homebrew: Initialize Homebrew based on OS
#

if [[ $OSTYPE == darwin* ]]; then
  export HOMEBREW_PREFIX=/opt/homebrew
elif [[ $OSTYPE == linux* ]]; then
  export HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew
fi

[[ -x "$HOMEBREW_PREFIX/bin/brew" ]] || return

eval "$(brew shellenv)"

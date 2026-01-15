#!/bin/zsh
#
# modern-tools.zsh - Modern CLI tool aliases and configurations
#

# Use modern tools if available
if command -v eza &>/dev/null; then
  alias ls='eza --group-directories-first --icons'
  alias ll='eza -l --group-directories-first --icons --git'
  alias la='eza -la --group-directories-first --icons --git'
  alias lt='eza --tree --level=2 --icons'
  alias tree='eza --tree --icons'
  alias l='eza --group-directories-first --icons'
fi

if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
  alias ccat='/bin/cat'  # Preserve original cat
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export BAT_THEME="Monokai Extended"
  export BAT_STYLE="numbers,changes,header"
fi

if command -v rg &>/dev/null; then
  alias grep='rg'
  alias ggrep='/usr/bin/grep'  # Preserve original grep
fi

if command -v fd &>/dev/null; then
  alias find='fd'
  alias ffind='/usr/bin/find'  # Preserve original find
fi

if command -v dust &>/dev/null; then
  alias du='dust'
  alias ddu='/usr/bin/du'  # Preserve original du
fi

if command -v duf &>/dev/null; then
  alias df='duf'
  alias ddf='/bin/df'  # Preserve original df
fi

if command -v procs &>/dev/null; then
  alias ps='procs'
  alias pps='/bin/ps'  # Preserve original ps
fi

if command -v btm &>/dev/null; then
  alias top='btm'
  alias htop='btm'
  alias ttop='/usr/bin/top'  # Preserve original top
fi

if command -v delta &>/dev/null; then
  export GIT_PAGER='delta'
fi

if command -v xh &>/dev/null; then
  alias curl='xh'
  alias ccurl='/usr/bin/curl'  # Preserve original curl
  alias http='xh'
  alias https='xh --https'
fi

if command -v doggo &>/dev/null; then
  alias dig='doggo'
  alias ddig='/usr/bin/dig'  # Preserve original dig
fi

if command -v hexyl &>/dev/null; then
  alias xxd='hexyl'
  alias hd='hexyl'
fi

if command -v tldr &>/dev/null; then
  alias help='tldr'
  alias man='tldr'
fi

if command -v gping &>/dev/null; then
  alias ping='gping'
  alias pping='/sbin/ping'  # Preserve original ping
fi

if command -v lazygit &>/dev/null; then
  alias lg='lazygit'
fi

# Disabled: sd has different syntax than sed and breaks VSCode shell integration
# if command -v sd &>/dev/null; then
#   alias sed='sd'
#   alias ssed='/usr/bin/sed'  # Preserve original sed
# fi

# Git aliases with modern tools
if command -v delta &>/dev/null; then
  alias gdiff='git diff'
  alias gshow='git show'
fi

if command -v difft &>/dev/null; then
  alias gdifft='git difftool --tool=difftastic'
  alias difftastic='difft'  # Alias for convenience
fi

alias glog='git log --oneline --graph --decorate --all'
alias gst='git status'
alias gco='git checkout'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'

# Quick benchmarking
if command -v hyperfine &>/dev/null; then
  alias bench='hyperfine'
fi

# Code statistics
if command -v tokei &>/dev/null; then
  alias cloc='tokei'
  alias loc='tokei'
fi

# Zoxide (smarter cd)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd='z'
  alias ccd='builtin cd'  # Preserve original cd
  alias zi='zi'  # Interactive zoxide
fi

# Better file operations
alias cp='cp -iv'  # Interactive, verbose
alias mv='mv -iv'  # Interactive, verbose
alias rm='rm -i'   # Interactive
alias mkdir='mkdir -pv'  # Create parent dirs, verbose

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Directory stack
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

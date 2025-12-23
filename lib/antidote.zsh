#
# Antidote
#

: ${ANTIDOTE_HOME:=${XDG_CACHE_HOME:-~/.cache}/repos}

# Keep all 3 for different test scenarios.
ANTIDOTE_REPO=$ANTIDOTE_HOME/mattmc3/antidote
# ANTIDOTE_REPO=~/Projects/mattmc3/antidote
# ANTIDOTE_REPO=${HOMEBREW_PREFIX:-/opt/homebrew}/opt/antidote/share/antidote

zstyle ':antidote:home' path $ANTIDOTE_HOME
zstyle ':antidote:repo' path $ANTIDOTE_REPO
zstyle ':antidote:bundle' use-friendly-names 'yes'
zstyle ':antidote:plugin:*' defer-options '-p'
zstyle ':antidote:*' zcompile 'yes'

# Clone antidote if necessary.
if [[ ! -d $ANTIDOTE_REPO ]]; then
  git clone https://github.com/mattmc3/antidote $ANTIDOTE_REPO
fi

# Load antidote
source $ANTIDOTE_REPO/antidote.zsh
antidote load

#
# Lazy-load heavy plugins with zsh-defer (instant startup)
#

# Path to lazy plugins (use XDG_CACHE_HOME as fallback)
: ${ANTIDOTE_HOME:=${XDG_CACHE_HOME:-~/.cache}/repos}

_LAZY_FAST_SYNTAX="$ANTIDOTE_HOME/zdharma-continuum/fast-syntax-highlighting"
_LAZY_AUTOSUGGESTIONS="$ANTIDOTE_HOME/zsh-users/zsh-autosuggestions"
_LAZY_HISTORY_SUBSTRING="$ANTIDOTE_HOME/zsh-users/zsh-history-substring-search"

# Load heavy plugins - zsh-defer will load them when idle
if [[ -f "$_LAZY_FAST_SYNTAX/fast-syntax-highlighting.plugin.zsh" ]]; then
  if (( $+functions[zsh-defer] )); then
    zsh-defer source "$_LAZY_FAST_SYNTAX/fast-syntax-highlighting.plugin.zsh"
  else
    source "$_LAZY_FAST_SYNTAX/fast-syntax-highlighting.plugin.zsh"
  fi
fi

if [[ -f "$_LAZY_AUTOSUGGESTIONS/zsh-autosuggestions.zsh" ]]; then
  if (( $+functions[zsh-defer] )); then
    zsh-defer source "$_LAZY_AUTOSUGGESTIONS/zsh-autosuggestions.zsh"
  else
    source "$_LAZY_AUTOSUGGESTIONS/zsh-autosuggestions.zsh"
  fi
fi

if [[ -f "$_LAZY_HISTORY_SUBSTRING/zsh-history-substring-search.plugin.zsh" ]]; then
  if (( $+functions[zsh-defer] )); then
    zsh-defer source "$_LAZY_HISTORY_SUBSTRING/zsh-history-substring-search.plugin.zsh"
  else
    source "$_LAZY_HISTORY_SUBSTRING/zsh-history-substring-search.plugin.zsh"
  fi
fi

unset _LAZY_FAST_SYNTAX _LAZY_AUTOSUGGESTIONS _LAZY_HISTORY_SUBSTRING

#
# Antidote
#

: ${ANTIDOTE_HOME:=${XDG_CACHE_HOME:-~/.cache}/repos}

# Keep all of these for different test scenarios.
ANTIDOTE_REPO=$ANTIDOTE_HOME/github.com/mattmc3/antidote
# ANTIDOTE_REPO=$ANTIDOTE_HOME/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-antidote
# ANTIDOTE_REPO=~/Projects/mattmc3/antidote
# ANTIDOTE_REPO=${HOMEBREW_PREFIX:-/opt/homebrew}/opt/antidote/share/antidote

zstyle ':antidote:home' path $ANTIDOTE_HOME
zstyle ':antidote:repo' path $ANTIDOTE_REPO
# zstyle ':antidote:bundle' use-friendly-names 'yes'
# zstyle ':antidote:bundle' path-style escaped
zstyle ':antidote:bundle' path-style full
zstyle ':antidote:plugin:*' defer-options '-p'
zstyle ':antidote:*' zcompile 'yes'

# Clone antidote if necessary.
if [[ ! -d $ANTIDOTE_REPO ]]; then
  git clone https://github.com/mattmc3/antidote $ANTIDOTE_REPO
fi

function antidote_reset() {
  rm ${ZDOTDIR:-$HOME}/.zsh_plugins.zsh
  rm -rf -- "${ANTIDOTE_HOME:-?}"
}

# Set the root name of the plugins files (.txt and .zsh) antidote will use.
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins

# Ensure the .zsh_plugins.txt file exists so you can add plugins.
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

# Prime common Zsh helper functions used by plugins before sourcing the bundle.
autoload -Uz add-zsh-hook add-zle-hook-widget colors is-at-least

# Regenerate the static plugins file only when the bundle list changes.
if [[ ! -f ${zsh_plugins}.zsh || ${zsh_plugins}.txt -nt ${zsh_plugins}.zsh ]]; then
  source $ANTIDOTE_REPO/antidote.zsh
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

# Prefer the static bundle on the hot path for faster startup.
if [[ -r ${zsh_plugins}.zsh ]]; then
  source ${zsh_plugins}.zsh
else
  source $ANTIDOTE_REPO/antidote.zsh
  antidote load
fi

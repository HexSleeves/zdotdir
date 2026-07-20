#
# Antidote
#

: ${ANTIDOTE_HOME:=${XDG_CACHE_HOME:-~/.cache}/repos}

# Keep all of these for different test scenarios.
ANTIDOTE_REPO=$ZDOTDIR/.antidote

zstyle ':antidote:home' path $ANTIDOTE_HOME
zstyle ':antidote:repo' path $ANTIDOTE_REPO
zstyle ':antidote:bundle' path-style full
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

# Lazy-load antidote from its functions directory.
fpath=($ANTIDOTE_REPO $fpath)
autoload -Uz antidote

# Generate a new static file whenever .zsh_plugins.txt is updated.
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

# Source the static plugins file.
source ${zsh_plugins}.zsh

# Clean fpath: remove git repo roots that antidote adds by default.
# These pollute the function namespace with non-function files
# (.gitignore, LICENSE, README.md, *.plugin.zsh, etc.).
# We only remove entries that contain a .git dir AND have no completion (_*) files.
local _fp
for _fp in $fpath; do
  [[ -d "$_fp/.git" ]] || continue
  set -- "$_fp"/_*(N)
  (( $# )) && continue  # keep if it has _completion files
  fpath=("${fpath[@]:#$_fp}")
done
unset _fp

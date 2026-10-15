# Set the root name of the plugins files (.txt and .zsh) antidote will use.
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins

# Ensure the .zsh_plugins.txt file exists so you can add plugins.
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

# Keep plugin clones out of cache dirs. The macOS default, ~/Library/Caches,
# is emptied by cache cleaners (mole's "User app cache" step), which leaves the
# static file below sourcing paths that no longer exist.
export ANTIDOTE_HOME=${ANTIDOTE_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/antidote}

# Lazy-load antidote from its functions directory.
fpath=($HOME/Projects/mattmc3/antidote/functions $fpath)
autoload -Uz antidote

# Generate a new static file whenever .zsh_plugins.txt is updated, or when the
# clones it points into are gone (bundling clones them again).
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt || ! -d $ANTIDOTE_HOME ]]; then
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

# Source your static plugins file.
source ${zsh_plugins}.zsh

# Clean up
unset zsh_plugins

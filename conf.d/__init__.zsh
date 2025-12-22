#
# __init__: This runs prior to any other conf.d contents.
#

# Apps
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less

# Set the list of directories that cd searches.
cdpath=(
  $XDG_PROJECTS_DIR(N/)
  $XDG_PROJECTS_DIR/mattmc3(N/)
  $cdpath
)

# Set the list of directories that Zsh searches for programs.
path=(
  # core
  $prepath
  $path

  # emacs
  $HOME/.emacs.d/bin(N)
  $XDG_CONFIG_HOME/emacs/bin(N)
)

# Keep these arrays unique to avoid bloating PATH/FPATH on repeated loads.
typeset -U path fpath cdpath

# Keep completion dumps in cache, not $HOME.
ZSH_COMPDUMP=${ZSH_COMPDUMP:-$ZSH_CACHE_DIR/.zcompdump}

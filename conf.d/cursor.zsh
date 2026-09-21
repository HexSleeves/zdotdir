#
# cursor
#

# Personal completion functions live in $ZSH_CONFIG_DIR/completions. z1 adds
# that dir to fpath itself, but with the `F` qualifier, which ignores
# dotfiles — a dir holding only `_cursor` counts as empty and never lands on
# fpath. Re-add it here without `F` (fpath is unique-typed, so no dupes if
# z1's glob ever matches). compinit runs later, in the post-zshrc hook, so
# this ordering is safe.
#
# NOTE: zsh_custom's compinit-fast serves any dump younger than 20h via
# `compinit -C` without rescanning fpath. After adding/editing a file in
# completions/, run:
#   rm -f $ZSH_CACHE_DIR/ZSH_COMPDUMP-${ZSH_VERSION}*
fpath=($ZSH_CONFIG_DIR/completions(-/N) $fpath)

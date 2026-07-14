#
# homebrew: Initialize Homebrew based on OS
# NOTE: brew shellenv is already sourced in ~/.config/shell/profile.sh via .zshenv.
# This file is now a guard — skip the redundant re-init entirely.
#

[[ -n "$HOMEBREW_PREFIX" ]] && return

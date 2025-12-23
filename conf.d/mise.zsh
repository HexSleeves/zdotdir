#
# mise
#

# Allow opting out by setting ZSH_ENABLE_MISE=0 before .zshrc loads.
[[ ${ZSH_ENABLE_MISE:-1} -eq 1 ]] || return

# Add mise shims to PATH (required for mise-managed tools to work)
typeset -gU PATH path
path=("$HOME/.local/share/mise/shims" $path)


if (( $+commands[mise] )); then
  # Use mise hook for faster startup than activate + eval
  if [[ -z ${_ZSH_MISE_ACTIVATED:-} ]]; then
    _ZSH_MISE_ACTIVATED=1
    eval "$(mise hook zsh 2>/dev/null)" || true
  fi
fi

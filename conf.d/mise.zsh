#
# mise
#

# Allow opting out by setting ZSH_ENABLE_MISE=0 before .zshrc loads.
[[ ${ZSH_ENABLE_MISE:-1} -eq 1 ]] || return
[[ -o interactive ]] || return

# Add mise shims to PATH (required for mise-managed tools to work)
typeset -gU PATH path
path=("$HOME/.local/share/mise/shims" $path)


if (( $+commands[mise] )); then
  _mise_init() {
    emulate -L zsh
    unset -f _mise_init
    eval "$(mise hook zsh 2>/dev/null)" || true
  }
  if (( $+functions[zsh-defer] )); then
    zsh-defer _mise_init
  else
    _mise_init
  fi
fi

#
# fzf (optional) - Lazy-loaded for faster startup
#

[[ ${ZSH_ENABLE_FZF:-1} -eq 1 ]] || return
(( $+commands[fzf] )) || return

# Prefer fd for faster file search; fall back to rg.
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
elif (( $+commands[rg] )); then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
  export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
fi

export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:---height 40% --layout=reverse --border}"

# Lazy-load fzf keybindings - load on first interactive use
_fzf_load_bindings() {
  unset -f _fzf_load_bindings __fzf_init_widget
  _fzf_bindings=(
    /opt/homebrew/opt/fzf/shell/key-bindings.zsh
    /usr/local/opt/fzf/shell/key-bindings.zsh
    $XDG_CONFIG_HOME/fzf/key-bindings.zsh
  )
  for _fzf_binding in $_fzf_bindings; do
    [[ -r $_fzf_binding ]] || continue
    source "$_fzf_binding"
    break
  done
  unset _fzf_bindings _fzf_binding
}

# Create a widget that loads fzf bindings on first use
zle -N __fzf_init_widget
__fzf_init_widget() { _fzf_load_bindings; zle .accept-line }

# Proxy common widgets to trigger lazy loading
for widget in viins vi-cmd-mode emacs; do
  zle -A $widget __fzf_proxy_$widget 2>/dev/null || true
done

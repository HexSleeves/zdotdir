#
# fzf (optional)
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

# Wire keybindings if the vendor script exists (brew installs it here).
_fzf_bindings=(
  /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  /usr/local/opt/fzf/shell/key-bindings.zsh
  $XDG_CONFIG_HOME/fzf/key-bindings.zsh
)
for _fzf_binding in $_fzf_bindings; do
  [[ -r $_fzf_binding ]] || continue
  source $_fzf_binding
  break
done
unset _fzf_bindings _fzf_binding

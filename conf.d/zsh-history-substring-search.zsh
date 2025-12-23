# Defer keybinding setup until after plugin loads via zsh-defer
_zsh_history_substring_bind() {
  # Check if the function exists (plugin loaded)
  (( $+functions[history-substring-search-up] )) || return 1

  # Emacs
  bindkey -M emacs '^P' history-substring-search-up
  bindkey -M emacs '^N' history-substring-search-down

  # Vi
  bindkey -M vicmd "k" history-substring-search-up
  bindkey -M vicmd "j" history-substring-search-down

  # Emacs and Vi
  for _keymap in 'emacs' 'viins'; do
    bindkey -M "$_keymap" "$terminfo[kcuu1]" history-substring-search-up
    bindkey -M "$_keymap" "$terminfo[kcud1]" history-substring-search-down
  done
  unset _keymap
}

# Defer keybinding setup if zsh-defer is available, otherwise run immediately
if (( $+functions[zsh-defer] )); then
  zsh-defer -t 0.1 _zsh_history_substring_bind
else
  _zsh_history_substring_bind
fi

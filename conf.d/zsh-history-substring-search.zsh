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

# if zstyle -t ':prezto:module:history-substring-search' case-sensitive; then
#   HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS="${HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS//i}"
# fi

# if ! zstyle -t ':prezto:module:history-substring-search' color; then
#   unset HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_{FOUND,NOT_FOUND}
# fi

# if zstyle -t ':prezto:module:history-substring-search' fuzzy; then
#   HISTORY_SUBSTRING_SEARCH_FUZZY=1
# fi

# if zstyle -t ':prezto:module:history-substring-search' unique; then
#   HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
# fi

# if zstyle -t ':prezto:module:history-substring-search' prefixed; then
#   HISTORY_SUBSTRING_SEARCH_PREFIXED=1
# fi

#
# Key Bindings
#

# Emacs
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# Vi
bindkey -M vicmd "k" history-substring-search-up
bindkey -M vicmd "j" history-substring-search-down

# Emacs and Vi
for _keymap in 'main' 'emacs' 'viins'; do
  bindkey -M "$_keymap" "$terminfo[kcuu1]" history-substring-search-up
  bindkey -M "$_keymap" "$terminfo[kcud1]" history-substring-search-down
done

unset _keymap

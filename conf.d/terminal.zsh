# Terminal

case "${TERM_PROGRAM:l}" in
  apple_terminal)
    export SHELL_SESSIONS_DISABLE=1
    ;;
  ghostty)
    [[ -f "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration" ]] && \
      source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
    ;;
  vscode)
    # https://code.visualstudio.com/docs/terminal/shell-integration
    typeset my_histfile=${HISTFILE:-$ZSH_DATA_DIR/.zsh_history}
    if command -v code &>/dev/null; then
      source "$(code --locate-shell-integration-path zsh)"
    fi
    HISTFILE=$my_histfile
    ;;
  wezterm)
    source "$ZDOTDIR/lib/wezterm-shell-integration.sh"
    function set_current_shell() {
      emulate -L zsh
      __wezterm_set_user_var "TERM_CURRENT_SHELL" "zsh ${${ZSH_PATCHLEVEL:-$ZSH_VERSION}#zsh-}"
    }
    set_current_shell
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd set_current_shell
    ;;
esac

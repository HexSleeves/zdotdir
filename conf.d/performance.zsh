#!/bin/zsh
#
# performance.zsh - Shell performance optimizations
#

[[ ${ZSH_BENCHMARK_MODE:-0} -eq 1 ]] && return
(( ${ZSH_INTERACTIVE_TTY:-0} )) || return

# Performance options
setopt NO_BEEP                   # Don't beep on errors
setopt MULTIOS                   # Enable multiple redirections
setopt INTERACTIVE_COMMENTS      # Allow comments in interactive shells
setopt EXTENDED_GLOB             # Extended globbing
setopt NO_FLOW_CONTROL          # Disable start/stop characters (^S/^Q)

# Directory options
setopt AUTO_CD                   # Auto cd to a directory without typing cd
setopt AUTO_PUSHD                # Push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS        # Do not store duplicates in the stack
setopt PUSHD_SILENT             # Do not print the directory stack after pushd or popd
setopt PUSHD_TO_HOME            # Push to home directory when no argument is given
setopt CDABLE_VARS              # Change directory to a path stored in a variable
setopt COMPLETE_IN_WORD         # Complete from both ends of a word
setopt ALWAYS_TO_END            # Move cursor to the end of a completed word
setopt PATH_DIRS                # Perform path search even on command names with slashes
setopt AUTO_MENU                # Show completion menu on a successive tab press
setopt AUTO_LIST                # Automatically list choices on ambiguous completion
setopt AUTO_PARAM_SLASH         # If completed parameter is a directory, add a trailing slash
setopt NO_MENU_COMPLETE         # Do not autoselect the first completion entry
setopt NO_COMPLETE_ALIASES      # Expand aliases before completion

autoload -Uz edit-command-line url-quote-magic zrecompile

# Function to recompile all zsh config files
recompile-zsh() {
  emulate -L zsh
  setopt local_options extendedglob nullglob
  local f
  for f in "$ZDOTDIR"/.zshrc(N) "$ZDOTDIR"/.zshenv(N) "$ZDOTDIR"/.zprofile(N) \
           "$ZDOTDIR"/**/*.zsh(N) "$ZDOTDIR"/**/*.zsh-theme(N); do
    [[ -f "$f" ]] || continue  # Skip if file doesn't exist
    zrecompile -pq "$f" 2>/dev/null && print -r -- "Compiled: ${f:t}"
  done
  print -r -- "Recompile complete. Restart your shell to see changes."
}

# macOS keyboard repeat helper (run manually, not at startup)
set-macos-key-repeat-fast() {
  emulate -L zsh
  [[ "$OSTYPE" == darwin* ]] || return 0
  defaults write NSGlobalDomain KeyRepeat -int 2
  defaults write NSGlobalDomain InitialKeyRepeat -int 15
  print -r -- "Applied macOS key repeat settings. Log out/in if needed."
}

# Smart URL pasting (prevent auto-escaping)
zle -N self-insert url-quote-magic

# Better word navigation (Alt+Arrow)
bindkey '^[[1;3C' forward-word      # Alt+Right
bindkey '^[[1;3D' backward-word     # Alt+Left
bindkey '^[[1;9C' forward-word      # Alt+Right (alternative)
bindkey '^[[1;9D' backward-word     # Alt+Left (alternative)

# Home/End keys
bindkey '^[[H' beginning-of-line    # Home
bindkey '^[[F' end-of-line          # End
bindkey '^[[1~' beginning-of-line   # Home (alternative)
bindkey '^[[4~' end-of-line         # End (alternative)

# Delete key
bindkey '^[[3~' delete-char         # Delete

# Ctrl+Arrow word navigation
bindkey '^[[1;5C' forward-word      # Ctrl+Right
bindkey '^[[1;5D' backward-word     # Ctrl+Left

# Better search (handled by zsh-history-substring-search.zsh)
# bindkey '^[[A' history-substring-search-up      # Up arrow
# bindkey '^[[B' history-substring-search-down    # Down arrow

# Quick clear screen
bindkey '^l' clear-screen

# Edit command line in editor
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Performance profiling shortcuts
alias zsh-startup='hyperfine --warmup 3 "ZSH_BENCHMARK_MODE=1 zsh -lic exit"'

# Quick reload
alias reload='exec zsh'
alias src='source ${ZDOTDIR:-$HOME}/.zshrc'

# Cleanup functions
clean-zsh-cache() {
  emulate -L zsh
  rm -rf "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"/*
  print -r -- "Zsh cache cleaned."
}

clean-zsh-compiled() {
  emulate -L zsh
  setopt local_options extendedglob nullglob
  rm -f -- "$ZDOTDIR"/**/*.zwc(N)
  print -r -- "Compiled files removed. Run 'recompile-zsh' to rebuild."
}

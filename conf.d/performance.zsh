#!/bin/zsh
#
# performance.zsh - Shell performance optimizations
#

# Lazy load NVM if needed (saves ~100-200ms on shell startup)
# if [[ -f /opt/homebrew/opt/nvm/nvm.sh ]]; then
#   export NVM_DIR="$HOME/.nvm"

#   # Lazy load nvm
#   nvm() {
#     unfunction nvm node npm npx
#     source /opt/homebrew/opt/nvm/nvm.sh
#     nvm "$@"
#   }

#   node() {
#     unfunction nvm node npm npx
#     source /opt/homebrew/opt/nvm/nvm.sh
#     node "$@"
#   }

#   npm() {
#     unfunction nvm node npm npx
#     source /opt/homebrew/opt/nvm/nvm.sh
#     npm "$@"
#   }

#   npx() {
#     unfunction nvm node npm npx
#     source /opt/homebrew/opt/nvm/nvm.sh
#     npx "$@"
#   }
# fi

# Better history settings
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000

# History options
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file
setopt HIST_VERIFY               # Do not execute immediately upon history expansion
setopt SHARE_HISTORY             # Share history between all sessions

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
setopt MULTIOS                  # Write to multiple descriptors
setopt EXTENDED_GLOB            # Use extended globbing syntax

# Completion options
setopt COMPLETE_IN_WORD         # Complete from both ends of a word
setopt ALWAYS_TO_END            # Move cursor to the end of a completed word
setopt PATH_DIRS                # Perform path search even on command names with slashes
setopt AUTO_MENU                # Show completion menu on a successive tab press
setopt AUTO_LIST                # Automatically list choices on ambiguous completion
setopt AUTO_PARAM_SLASH         # If completed parameter is a directory, add a trailing slash
setopt NO_MENU_COMPLETE         # Do not autoselect the first completion entry
setopt NO_COMPLETE_ALIASES      # Expand aliases before completion

# Compile zsh files for faster loading
autoload -Uz zrecompile

# Function to recompile all zsh config files
recompile-zsh() {
  local f
  for f in ~/.zshrc(N) ~/.zshenv(N) ~/.zprofile(N) ~/.config/zsh/**/*.zsh(N); do
    [[ -f "$f" ]] || continue  # Skip if file doesn't exist
    zrecompile -pq "$f" 2>/dev/null && print -r -- "Compiled: ${f:t}"
  done
  print -r -- "Recompile complete. Restart your shell to see changes."
}

# Compile config files on first load (async)
{
  setopt LOCAL_OPTIONS EXTENDED_GLOB
  local zfile
  # Only compile files that exist
  for zfile in ${ZDOTDIR:-$HOME}/.zshrc(N) ${ZDOTDIR:-$HOME}/.zprofile(N) \
               ${ZDOTDIR:-$HOME}/.zshenv(N) ${ZDOTDIR:-$HOME}/.config/zsh/**/*.zsh(N); do
    [[ -f "$zfile" ]] || continue  # Skip if file doesn't exist
    if [[ ! -s "${zfile}.zwc" ]] || [[ "$zfile" -nt "${zfile}.zwc" ]]; then
      zcompile "$zfile" 2>/dev/null
    fi
  done
} &!

# macOS keyboard repeat helper (run manually, not at startup)
set-macos-key-repeat-fast() {
  [[ "$OSTYPE" == darwin* ]] || return 0
  defaults write NSGlobalDomain KeyRepeat -int 2
  defaults write NSGlobalDomain InitialKeyRepeat -int 15
  print -r -- "Applied macOS key repeat settings. Log out/in if needed."
}

# Smart URL pasting (prevent auto-escaping)
autoload -Uz url-quote-magic
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

# Better search
bindkey '^[[A' history-substring-search-up      # Up arrow
bindkey '^[[B' history-substring-search-down    # Down arrow

# Quick clear screen
bindkey '^l' clear-screen

# Edit command line in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Performance profiling shortcuts
alias zsh-bench='for i in {1..10}; do time zsh -lic "exit"; done'
alias zsh-startup='hyperfine --warmup 3 "zsh -lic exit"'

# Quick reload
alias reload='exec zsh'
alias src='source ${ZDOTDIR:-$HOME}/.zshrc'

# Cleanup functions
clean-zsh-cache() {
  rm -rf "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"/*
  print -r -- "Zsh cache cleaned."
}

clean-zsh-compiled() {
  rm -f "${ZDOTDIR:-$HOME}/.config/zsh"/**/*.zwc(N)
  print -r -- "Compiled files removed. Run 'recompile-zsh' to rebuild."
}

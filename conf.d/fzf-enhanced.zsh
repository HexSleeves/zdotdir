#!/bin/zsh
#
# fzf-enhanced.zsh - Enhanced FZF configuration
#

if command -v fzf &>/dev/null; then
  # Use fd for file finding if available
  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules'
  elif command -v rg &>/dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!node_modules/*"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi

  # Use bat for preview if available
  if command -v bat &>/dev/null; then
    export FZF_CTRL_T_OPTS="
      --preview 'bat --color=always --style=numbers --line-range=:500 {}'
      --preview-window right:60%:wrap
    "
  fi

  # Enhanced directory preview
  if command -v eza &>/dev/null; then
    export FZF_ALT_C_OPTS="
      --preview 'eza --tree --level=2 --icons --color=always {} | head -200'
      --preview-window right:50%
    "
  elif command -v tree &>/dev/null; then
    export FZF_ALT_C_OPTS="
      --preview 'tree -C {} | head -200'
      --preview-window right:50%
    "
  fi

  # Enhanced appearance with Catppuccin-inspired colors
  export FZF_DEFAULT_OPTS="
    --height 60%
    --layout=reverse
    --border rounded
    --inline-info
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
    --bind='ctrl-/:toggle-preview'
    --bind='ctrl-u:preview-page-up'
    --bind='ctrl-d:preview-page-down'
    --bind='ctrl-a:select-all'
    --bind='ctrl-y:execute-silent(echo -n {+} | pbcopy)'
    --bind='ctrl-e:execute(echo {+} | xargs -o ${EDITOR:-vim})'
  "

  # Git integration functions
  fzf-git-branch() {
    local branches branch
    branches=$(git branch -a | grep -v HEAD) &&
    branch=$(echo "$branches" | fzf +m) &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
  }
  zle -N fzf-git-branch
  bindkey '^g^b' fzf-git-branch

  fzf-git-log() {
    local commits commit
    commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
    commit=$(echo "$commits" | fzf --ansi +s +m -e) &&
    git show $(echo "$commit" | sed "s/ .*//")
  }
  zle -N fzf-git-log
  bindkey '^g^l' fzf-git-log

  # File search with preview
  fzf-file-widget() {
    local file
    file=$(fzf --query "$LBUFFER" --select-1 --exit-0)
    if [[ -n "$file" ]]; then
      LBUFFER="${LBUFFER}${file}"
    fi
    zle reset-prompt
  }
  zle -N fzf-file-widget
  bindkey '^p' fzf-file-widget

  # Process killer
  fzf-kill() {
    local pid
    if command -v procs &>/dev/null; then
      pid=$(procs | sed 1d | fzf -m | awk '{print $1}')
    else
      pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [[ -n "$pid" ]]; then
      echo "$pid" | xargs kill -${1:-9}
    fi
  }
  alias fkill='fzf-kill'

  # Environment variable viewer
  fzf-env() {
    env | fzf --preview 'echo {}' --preview-window down:3:wrap
  }
  alias fenv='fzf-env'

  # Command history search (if not using atuin)
  if ! command -v atuin &>/dev/null; then
    fzf-history-widget() {
      local selected
      selected=$(fc -rl 1 | awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' |
        fzf --query "$LBUFFER" --tac --no-sort --exact)
      if [[ -n "$selected" ]]; then
        LBUFFER=$(echo "$selected" | sed 's/^[ \t]*[0-9]*\** *//')
      fi
      zle reset-prompt
    }
    zle -N fzf-history-widget
    bindkey '^r' fzf-history-widget
  fi

  # Tmux session selector
  if command -v tmux &>/dev/null; then
    fzf-tmux-session() {
      local session
      session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0)
      if [[ -n "$session" ]]; then
        tmux switch-client -t "$session"
      fi
    }
    alias fts='fzf-tmux-session'
  fi

  # SSH host selector
  fzf-ssh() {
    local host
    host=$(grep -E '^Host ' $HOME/.ssh/config 2>/dev/null |
      grep -v '*' |
      awk '{print $2}' |
      fzf --exit-0)
    if [[ -n "$host" ]]; then
      ssh "$host"
    fi
  }
  alias fssh='fzf-ssh'

  # Docker container selector
  if command -v docker &>/dev/null; then
    fzf-docker() {
      local container
      container=$(docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}" |
        tail -n +2 |
        fzf --header-lines=0)
      if [[ -n "$container" ]]; then
        local container_id=$(echo "$container" | awk '{print $1}')
        docker exec -it "$container_id" /bin/bash || docker exec -it "$container_id" /bin/sh
      fi
    }
    alias fdocker='fzf-docker'
  fi

  # Kubernetes pod selector
  if command -v kubectl &>/dev/null; then
    fzf-kubectl() {
      local pod
      pod=$(kubectl get pods --all-namespaces |
        tail -n +2 |
        fzf --header-lines=0)
      if [[ -n "$pod" ]]; then
        local namespace=$(echo "$pod" | awk '{print $1}')
        local pod_name=$(echo "$pod" | awk '{print $2}')
        kubectl exec -it -n "$namespace" "$pod_name" -- /bin/bash || \
        kubectl exec -it -n "$namespace" "$pod_name" -- /bin/sh
      fi
    }
    alias fkube='fzf-kubectl'
  fi
fi

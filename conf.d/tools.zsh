# Tool-specific PATH and environment hooks.

[[ -d "$HOME/.opencode/bin" ]] && path=("$HOME/.opencode/bin" $path)
[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)
[[ -r "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

# Mole shell completion
if command -v mole &>/dev/null; then
  if (( $+functions[cached-eval] )); then
    cached-eval 'mole-completion' mole completion zsh
  elif output="$(mole completion zsh 2>/dev/null)"; then
    eval "$output"
  fi
fi


# opencode
export PATH="$HOME/.opencode/bin:$PATH"
export PATH="/Users/lecoqjacob/.cap/bin:$PATH"

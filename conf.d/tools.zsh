# Tool-specific PATH and environment hooks.

[[ -d "$HOME/.opencode/bin" ]] && path=("$HOME/.opencode/bin" $path)
[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)
[[ -r "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

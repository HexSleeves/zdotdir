#
# bun
#

# Allow opting out by setting ZSH_ENABLE_BUN=0 before .zshrc loads.
[[ ${ZSH_ENABLE_BUN:-1} -eq 1 ]] || return

# Default bun install location; matches bun's installer default here.
export BUN_INSTALL="${BUN_INSTALL:-$HOME/.cache/.bun}"

# Add bun to PATH if present.
if [[ -d "$BUN_INSTALL/bin" ]]; then
  path=($BUN_INSTALL/bin $path)
fi

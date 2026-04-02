# pnpm
export PNPM_HOME="${PNPM_HOME:-$XDG_DATA_HOME/pnpm}"
[[ -d "$PNPM_HOME" ]] && path=("$PNPM_HOME" $path)

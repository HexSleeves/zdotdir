# multijob.zsh — cross-job / multi-MacBook context switching
# Part of the multi-job automation kit (see ~/.local/bin/workswitch).

# Ensure workswitch is on PATH (redundant with tools.zsh but safe)
[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)

# Print the active job profile, or "none" if unset
job() {
  if [[ -n "$WORK_PROFILE" ]]; then
    echo "active job: $WORK_PROFILE${ADOBE_ENV:+ (env: $ADOBE_ENV)}"
  else
    echo "active job: none (run: workswitch adobe|liatrio|personal)"
  fi
}

# Quick switchers (shorter than typing workswitch each time)
alias wa='workswitch adobe'
alias wl='workswitch liatrio'
alias wp='workswitch personal'

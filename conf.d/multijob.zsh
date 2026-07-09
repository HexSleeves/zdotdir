# multijob.zsh — cross-job / multi-MacBook context switching
[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)
job() {
  if [[ -n "$WORK_PROFILE" ]]; then
    echo "active job: $WORK_PROFILE${ADOBE_ENV:+ (env: $ADOBE_ENV)}"
  else
    echo "active job: none (run: workswitch adobe|liatrio|personal)"
  fi
}
alias wa="workswitch adobe"
alias wl="workswitch liatrio"
alias wp="workswitch personal"

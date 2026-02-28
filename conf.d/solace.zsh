#
# solace
#

# Allow opting out entirely.
[[ ${ZSH_ENABLE_SOLACE:-1} -eq 1 ]] || return

# Path to an untracked file where AWS credentials/profile exports live.
: ${SOLACE_ENV_FILE:=$ZSH_CONFIG_DIR/conf.d/solace.local.zsh}

# Common variables you might set in the local file:
#   NPM_TOKEN

if [[ -f "$SOLACE_ENV_FILE" ]]; then
  setopt localoptions allexport
  source "$SOLACE_ENV_FILE"
  unsetopt allexport
fi

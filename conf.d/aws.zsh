#
# aws
#

# Allow opting out entirely.
[[ ${ZSH_ENABLE_AWS:-1} -eq 1 ]] || return

# Path to an untracked file where AWS credentials/profile exports live.
: ${AWS_ENV_FILE:=$ZSH_CONFIG_DIR/conf.d/aws.local.zsh}

# Common variables you might set in the local file:
#   AWS_PROFILE, AWS_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY,
#   AWS_SESSION_TOKEN, AWS_DEFAULT_OUTPUT

if [[ -f "$AWS_ENV_FILE" ]]; then
  setopt localoptions allexport
  source "$AWS_ENV_FILE"
  unsetopt allexport
fi

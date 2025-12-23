#
# AI provider secrets
#

# Allow opting out entirely.
[[ ${ZSH_ENABLE_AI_PROVIDERS:-1} -eq 1 ]] || return

# Path to a local, untracked file that exports API keys for AI services.
# The default stays inside this repo but uses a *.local.zsh filename so it
# is ignored by git. Override AI_PROVIDERS_FILE to point somewhere else.
: ${AI_PROVIDERS_FILE:=$ZSH_CONFIG_DIR/conf.d/ai-providers.local.zsh}

# Suggested variables (set in your local file):
#   OPENAI_API_KEY
#   ANTHROPIC_API_KEY
#   OPENROUTER_API_KEY
#   DEEPSEEK_API_KEY
#   GEMINI_API_KEY
#   MISTRAL_API_KEY

if [[ -f "$AI_PROVIDERS_FILE" ]]; then
  setopt localoptions allexport
  source "$AI_PROVIDERS_FILE"
  unsetopt allexport
fi

# opencode
export PATH=/Users/jacob.lecoq.ext/.opencode/bin:$PATH

#
# prompt: Set up the Zsh prompt system.
#

# Initialize prompt with Powerlevel10k instant prompt
setopt prompt_subst transient_rprompt

# Powerlevel10k instant prompt - must be at the top of .zshrc
# This is handled by .p10k.zsh which should be sourced before .zshrc

# Load p10k prompt theme
autoload -Uz promptinit && promptinit
[[ -f $ZDOTDIR/themes/mmc.p10k.zsh ]] && source $ZDOTDIR/themes/mmc.p10k.zsh
prompt_powerlevel10k_setup 2>/dev/null || true

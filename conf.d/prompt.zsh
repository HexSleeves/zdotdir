#
# prompt: Set up the Zsh prompt system.
#

# Initialize prompt with Powerlevel10k instant prompt
(( ${ZSH_INTERACTIVE_TTY:-0} )) || return
setopt prompt_subst transient_rprompt
[[ ${ZSH_BENCHMARK_MODE:-0} -eq 1 ]] && return
[[ -r "$ZDOTDIR/.p10k.zsh" ]] && source "$ZDOTDIR/.p10k.zsh"

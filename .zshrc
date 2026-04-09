# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ ${ZSH_BENCHMARK_MODE:-0} -ne 1 ]] && [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#!/bin/zsh
#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

# Profiling
[[ "$ZPROFRC" -ne 1 ]] || zmodload zsh/zprof
alias zprofrc="ZPROFRC=1 zsh"

# Set Zsh location vars.
ZSH_CONFIG_DIR="${ZSH_CONFIG_DIR:-${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}}"
ZSH_DATA_DIR="${ZSH_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/zsh}"
ZSH_CACHE_DIR="${ZSH_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh}"
mkdir -p -- "$ZSH_CONFIG_DIR" "$ZSH_DATA_DIR" "$ZSH_CACHE_DIR"

# Set essential options
setopt EXTENDED_GLOB INTERACTIVE_COMMENTS
typeset -gi ZSH_INTERACTIVE_TTY=0
[[ -t 0 && -t 1 && -t 2 ]] && ZSH_INTERACTIVE_TTY=1

# Add custom completions
fpath=("$ZSH_CONFIG_DIR/completions" $fpath)

# Lazy-load (autoload) Zsh function files from a directory.
typeset -a _fndirs
_fndirs=("$ZSH_CONFIG_DIR"/functions(N/F) "$ZSH_CONFIG_DIR"/functions/*(N/F))
for _fndir in $_fndirs; do
  fpath=($_fndir $fpath)
  autoload -Uz $_fndir/*~*/_*(N.:t)
done
unset _fndir _fndirs

# Set any zstyles you might use for configuration.
[[ -r "$ZSH_CONFIG_DIR/.zstyles" ]] && source "$ZSH_CONFIG_DIR/.zstyles"

# Create an amazing Zsh config using antidote plugins.
if [[ ${ZSH_BENCHMARK_MODE:-0} -ne 1 ]] && (( ZSH_INTERACTIVE_TTY )); then
  source "$ZSH_CONFIG_DIR/lib/antidote.zsh"
fi

IGNORE_LIST=(
  jupyter.zsh
  nim.zsh
)

# Source conf.d.zsh
for _rc in "$ZSH_CONFIG_DIR"/conf.d/*.zsh(N); do
  # ignore files that begin with ~
  [[ "${_rc:t}" != '~'* ]] || continue
  [[ "${IGNORE_LIST[(I)${_rc:t}]}" -eq 0 ]] || continue
  source "$_rc"
done
unset _rc

autoload -Uz compinit
ZSH_COMPDUMP=$XDG_CACHE_HOME/zsh/zcompdump
compinit -i -d "$ZSH_COMPDUMP"

# Never start in the root file system.
[[ "$PWD" != "/" ]] || cd

# Local settings
[ -r $HOME/.local/config/zsh/.zshrc.local ] \
&& . $HOME/.local/config/zsh/.zshrc.local


# >>> forge initialize >>>
# !! Contents within this block are managed by 'forge zsh setup' !!
# !! Do not edit manually - changes will be overwritten !!

# Add required zsh plugins if not already present
if [[ ! " ${plugins[@]} " =~ " zsh-autosuggestions " ]]; then
    plugins+=(zsh-autosuggestions)
fi
if [[ ! " ${plugins[@]} " =~ " zsh-syntax-highlighting " ]]; then
    plugins+=(zsh-syntax-highlighting)
fi

# Load forge shell plugin (commands, completions, keybindings) if not already loaded
if [[ ${ZSH_BENCHMARK_MODE:-0} -ne 1 ]] && (( ZSH_INTERACTIVE_TTY )) && (( $+commands[forge] )) && [[ -z "$_FORGE_PLUGIN_LOADED" ]]; then
    eval "$(forge zsh plugin)"
fi

# Load forge shell theme (prompt with AI context) if not already loaded
if [[ ${ZSH_BENCHMARK_MODE:-0} -ne 1 ]] && (( ZSH_INTERACTIVE_TTY )) && (( $+commands[forge] )) && [[ -z "$_FORGE_THEME_LOADED" ]]; then
    eval "$(forge zsh theme)"
fi
# <<< forge initialize <<<

# Finish profiling by calling zprof.
[[ "$ZPROFRC" -eq 1 ]] && zprof
[[ -v ZPROFRC ]] && unset ZPROFRC

# Always return success
true

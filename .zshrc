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
typeset -i _had_null_glob=0
[[ -o null_glob ]] && _had_null_glob=1
setopt null_glob

typeset -a _fndirs
_fndirs=("$ZSH_CONFIG_DIR/functions" "$ZSH_CONFIG_DIR"/functions/*)
for _fndir in "${_fndirs[@]}"; do
  [[ -d "$_fndir" ]] || continue
  fpath=("$_fndir" $fpath)
  for _fn in "$_fndir"/*; do
    [[ -f "$_fn" ]] || continue
    [[ "${_fn##*/}" != _* ]] || continue
    autoload -Uz "${_fn##*/}"
  done
done
unset _fndir _fndirs _fn

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
for _rc in "$ZSH_CONFIG_DIR"/conf.d/*.zsh; do
  [[ -f "$_rc" ]] || continue
  _rc_name="${_rc##*/}"
  # ignore files that begin with ~
  [[ "$_rc_name" != '~'* ]] || continue
  [[ " ${IGNORE_LIST[*]} " != *" ${_rc_name} "* ]] || continue
  source "$_rc"
done
unset _rc _rc_name

(( _had_null_glob )) || unsetopt null_glob
unset _had_null_glob

# Never start in the root file system.
[[ "$PWD" != "/" ]] || cd || exit

# Local settings
[ -r "$HOME"/.local/config/zsh/.zshrc.local ] \
&& . "$HOME"/.local/config/zsh/.zshrc.local


# >>> forge initialize >>>
# !! Contents within this block are managed by 'forge zsh setup' !!
# !! Do not edit manually - changes will be overwritten !!

# Add required zsh plugins if not already present
typeset -i _has_autosuggestions=0 _has_syntax_highlighting=0
for _plugin in "${plugins[@]}"; do
    [[ "$_plugin" == "zsh-autosuggestions" ]] && _has_autosuggestions=1
    [[ "$_plugin" == "zsh-syntax-highlighting" ]] && _has_syntax_highlighting=1
done
(( _has_autosuggestions )) || plugins+=(zsh-autosuggestions)
(( _has_syntax_highlighting )) || plugins+=(zsh-syntax-highlighting)
unset _plugin _has_autosuggestions _has_syntax_highlighting

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

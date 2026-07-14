#
# grok
#

if [[ ! -x "$HOME/.grok/bin/grok" ]] && (( ! $+commands[grok] )); then
  return 0
fi

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
# <<< grok installer <<<

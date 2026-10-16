# project jumper
cached-eval prj -i zsh

# .envrc source. direnv's own hook execs `direnv export` before every prompt
# (~12ms). Run it on directory change instead, and only when an .envrc is up the
# tree or one is already loaded. After editing an .envrc, run `direnv reload`.
cached-eval direnv hook zsh
precmd_functions=(${precmd_functions:#_direnv_hook})
chpwd_functions=(${chpwd_functions:#_direnv_hook})
function _direnv_hook_if_needed() {
  local d=$PWD
  if [[ -z ${DIRENV_DIR-} ]]; then
    until [[ -e $d/.envrc ]]; do
      [[ $d == / ]] && return
      d=${d:h}
    done
  fi
  _direnv_hook
}
chpwd_functions=(_direnv_hook_if_needed $chpwd_functions)
_direnv_hook_if_needed

# Without a prompt hook, apply what these subcommands change right away.
function direnv() {
  command direnv "$@"
  local ret=$?
  case $1 in
    allow|permit|grant|deny|block|revoke|reload|edit) _direnv_hook ;;
  esac
  return ret
}

# frecency cd replacement
cached-eval zoxide init zsh
# x-shell completions
export CARAPACE_BRIDGES="${CARAPACE_BRIDGES:-fish,bash}"
is-warp || cached-eval carapace _carapace

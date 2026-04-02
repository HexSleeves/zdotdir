#
# prj: Project jumper
#

[[ -o interactive ]] || return

if [[ -x "$ZSH_CONFIG_DIR/bin/prj" ]]; then
  prj() {
    emulate -L zsh
    unfunction prj
    eval "$("$ZSH_CONFIG_DIR/bin/prj" -i zsh)"
    prj "$@"
  }
fi

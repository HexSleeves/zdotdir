#
# cache-helpers: source expensive tool init from a byte-compiled cache.
#

# cached-source <name> <command...>
#
# Runs <command> at most once per 20h, caching its stdout, byte-compiling it,
# and sourcing the result. zsh automatically prefers a newer <file>.zwc, so
# later startups parse bytecode instead of re-forking the tool and re-parsing
# its output.
#
# Differs from the older `cached-eval` in two ways: it byte-compiles, and it
# writes through a temp file so a failed or partial run can never leave a
# truncated cache that later shells would source.
cached-source() {
  emulate -L zsh
  setopt local_options extended_glob
  (( $# >= 2 )) || return 1

  local name=$1; shift
  local f=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/cached-eval/$name.zsh
  local -a fresh=($f(Nmh-20))

  if [[ ! -s $f ]] || (( ! ${#fresh} )); then
    local tmp=$f.$$.tmp
    mkdir -p ${f:h}
    if ! "$@" >| $tmp 2>/dev/null || [[ ! -s $tmp ]]; then
      command rm -f $tmp
      return 1
    fi
    command mv -f $tmp $f
    zcompile -R -- $f 2>/dev/null
  fi

  source $f
}

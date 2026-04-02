#!/bin/zsh

emulate -L zsh
setopt errexit nounset pipefail

repo_root=${0:A:h:h}
tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/zsh-regression.XXXXXX")
trap 'rm -rf -- "$tmpdir"' EXIT

stub_bin=$tmpdir/bin
mkdir -p -- "$stub_bin"

cat >"$stub_bin/bw" <<'EOF'
#!/bin/zsh
emulate -L zsh
print -r -- "$*" >>"${ZSH_TEST_BW_LOG:?}"
case "${1:-}" in
  status)
    print -r -- '{"status":"unlocked","userEmail":"test@example.com"}'
    ;;
  *)
    exit 0
    ;;
esac
EOF

cat >"$stub_bin/security" <<'EOF'
#!/bin/zsh
emulate -L zsh
local service=""
while (( $# )); do
  case "$1" in
    -s)
      shift
      service=${1:-}
      ;;
  esac
  shift
done
case "$service" in
  BW_SESSION)
    print -r -- "stub-session"
    ;;
  BW_CLIENTID)
    print -r -- "stub-client-id"
    ;;
  BW_CLIENTSECRET)
    print -r -- "stub-client-secret"
    ;;
esac
EOF

chmod +x "$stub_bin/bw" "$stub_bin/security"

export ZSH_TEST_BW_LOG="$tmpdir/bw.log"
: >"$ZSH_TEST_BW_LOG"

startup_snapshot=$(
  PATH="$stub_bin:$PATH" ZDOTDIR="$repo_root" zsh -lic '
    print -r -- "HISTFILE=$HISTFILE"
    print -r -- "PATH=${(j.:.)path}"
    alias history 2>/dev/null || true
    alias cd 2>/dev/null || true
  ' 2>/dev/null
)

assert_eq() {
  local actual=$1
  local expected=$2
  local message=$3
  if [[ "$actual" != "$expected" ]]; then
    print -ru2 -- "FAIL: $message"
    print -ru2 -- "  expected: $expected"
    print -ru2 -- "  actual:   $actual"
    exit 1
  fi
}

assert_not_contains() {
  local haystack=$1
  local needle=$2
  local message=$3
  if [[ "$haystack" == *"$needle"* ]]; then
    print -ru2 -- "FAIL: $message"
    print -ru2 -- "  unexpected substring: $needle"
    exit 1
  fi
}

assert_file_empty() {
  local file=$1
  local message=$2
  if [[ -s "$file" ]]; then
    print -ru2 -- "FAIL: $message"
    print -ru2 -- "  contents:"
    sed 's/^/    /' "$file" >&2
    exit 1
  fi
}

expected_histfile="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/.zsh_history"
histfile_line=${${(M)${(f)startup_snapshot}:#HISTFILE=*}#HISTFILE=}
path_line=${${(M)${(f)startup_snapshot}:#PATH=*}#PATH=}

assert_eq "$histfile_line" "$expected_histfile" "startup should preserve the XDG zsh history path"
assert_not_contains "$path_line" "/Users/jacob.lecoq.ext/" "startup PATH should not include stale external-user directories"
assert_file_empty "$ZSH_TEST_BW_LOG" "startup should not invoke bw"

print -r -- "regression-startup: PASS"

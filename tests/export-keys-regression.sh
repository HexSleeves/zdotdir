#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script="$repo_root/home/dot_config/dotfiles/executable_export-keys.sh"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

bin_dir="$tmpdir/bin"
source_dir="$tmpdir/source"
archive_path="$source_dir/bootstrap/gpg/gpg-keyring.tgz.gpg"

mkdir -p "$bin_dir" "$(dirname "$archive_path")"

cat >"$bin_dir/gpg" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "--version" ]]; then
  echo "gpg (fake) 0.0"
  exit 0
fi

if [[ "${1:-}" == "--export-ownertrust" ]]; then
  echo "ownertrust"
  exit 0
fi

output=""
args=("$@")
for ((i = 0; i < ${#args[@]}; i++)); do
  case "${args[$i]}" in
    -o|--output)
      output="${args[$((i + 1))]}"
      ;;
  esac
done

if [[ -n "$output" ]]; then
  mkdir -p "$(dirname "$output")"
  : >"$output"
fi
EOF

chmod 700 "$bin_dir/gpg"

stdout_path="$tmpdir/stdout"
stderr_path="$tmpdir/stderr"

set +e
PATH="$bin_dir:$PATH" bash "$script" --chezmoi --chezmoi-source "$source_dir" --output "$archive_path" >"$stdout_path" 2>"$stderr_path"
status=$?
set -e

if [[ $status -ne 0 ]]; then
  echo "expected export helper to succeed, got exit code $status" >&2
  sed -n '1,120p' "$stdout_path" >&2
  sed -n '1,120p' "$stderr_path" >&2
  exit 1
fi

if [[ ! -f "$archive_path" ]]; then
  echo "expected archive to be created at $archive_path" >&2
  exit 1
fi

if [[ -s "$stderr_path" ]]; then
  echo "expected empty stderr" >&2
  sed -n '1,120p' "$stderr_path" >&2
  exit 1
fi

echo "export helper regression test passed"

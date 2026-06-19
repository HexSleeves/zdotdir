#
# macOS-specific paths
#

[[ $OSTYPE == darwin* ]] || return

# Homebrew keg-only bins and ruby gems.
path=(
  $HOMEBREW_PREFIX/opt/curl/bin(N)
  $HOMEBREW_PREFIX/opt/go/libexec/bin(N)
  $HOMEBREW_PREFIX/share/npm/bin(N)
  $path
)

# /usr/local/bin for manually-installed CLIs (tailscale, etc.)
path=(
  /opt/homebrew/bin(N)
  /usr/local/bin(N)
  $path
)

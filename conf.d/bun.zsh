#
# bun: Global package bins.
#

# With XDG_CACHE_HOME set, bun installs globals under it instead of ~/.bun.
export BUN_INSTALL=${BUN_INSTALL:-${XDG_CACHE_HOME:-$HOME/.cache}/.bun}
path=($BUN_INSTALL/bin(N) $path)

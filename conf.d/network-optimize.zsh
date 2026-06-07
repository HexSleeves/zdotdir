#!/bin/zsh
#
# network-optimize.zsh - Persistent network optimizations
#

# Apply TCP tuning on shell login (non-sudo parts only)
if [[ "$OSTYPE" == darwin* ]]; then
  # Faster cURL defaults (used by many CLI tools)
  export CURL_CA_BUNDLE=""
  export CURL_CONNECT_TIMEOUT=5
  export CURL_MAX_TIME=30

  # Faster wget
  export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"

  # DNS optimization: prefer IPv4 for faster resolution on most networks
  export CURL_IPRESOLVE=1
fi

#
# rust
#

# rust vars
export CARGO_HOME="${CARGO_HOME:-$XDG_DATA_HOME/cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-$XDG_DATA_HOME/rustup}"

if [[ -r $HOME/.config/broot/launcher/bash/br ]]; then
  br() {
    unfunction br
    source $HOME/.config/broot/launcher/bash/br
    br "$@"
  }
fi

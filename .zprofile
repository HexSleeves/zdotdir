# profile.sh is sourced in .zshenv (runs for all shells), so don't
# re-source ~/.profile here — that would double-load brew/cargo/PATH setup.

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

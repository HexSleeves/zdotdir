#
# mise: Polyglot runtime manager.
#

(( $+commands[mise] )) || return 1

# Not cached: the hook embeds mise's absolute path, which breaks when mise moves.
eval "$(mise activate zsh)"

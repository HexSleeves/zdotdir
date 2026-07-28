#
# forge-cache: preload forge's shell plugin and theme from a compiled cache.
#
# `forge zsh plugin` forks forge and emits ~167KB of shell to eval; together
# with `forge zsh theme` it cost ~46ms of every interactive startup — the
# single largest item in the trace.
#
# The generated output sets _FORGE_PLUGIN_LOADED / _FORGE_THEME_LOADED itself,
# so sourcing the cache here makes the guards in forge.zsh skip the expensive
# evals. This file sorts before forge.zsh ('-' precedes '.'), which leaves
# forge.zsh untouched and still regenerable by `forge zsh setup`.

[[ -o interactive ]] || return
(( $+commands[forge] )) || return
(( $+functions[cached-source] )) || return

cached-source forge-zsh-plugin forge zsh plugin
cached-source forge-zsh-theme forge zsh theme

# zsh parameter completion for the dotnet CLI
# https://learn.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete

# Add .NET Core SDK tools
if [[ -d $HOME/.dotnet/tools ]]; then
  path+=($HOME/.dotnet/tools)
fi

# nuget
export NUGET_PACKAGES="${NUGET_PACKAGES:-$XDG_CACHE_HOME/NuGetPackages}"

# Defer completion setup until after compinit runs
_dotnet_zsh_complete() {
  local completions=("$(dotnet complete "$words")")

  # If the completion list is empty, just continue with filename selection
  if [ -z "$completions" ]
  then
    _arguments '*::arguments: _normal'
    return
  fi

  # This is not a variable assignment, don't remove spaces!
  _values = "${(ps:\n:)completions}"
}

# Register completion after compinit (using add-zsh-hook if available)
if (( $+functions[add-zsh-hook] )); then
  add-zsh-hook -Uz zshdelete '_dotnethookcleanup' 2>/dev/null || true
fi

autoload -Uz +X compinit && compinit -C -d "${ZSH_COMPDUMP}"
compdef _dotnet_zsh_complete dotnet 2>/dev/null || true

#
# nvm - Lazy-loaded for fast shell startup
#

# Allow opting out by setting ZSH_ENABLE_NVM=0 before .zshrc loads.
[[ ${ZSH_ENABLE_NVM:-1} -eq 1 ]] || return

# Detect NVM installation: Homebrew (macOS) takes priority
if [[ -f "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
  export NVM_DIR="/opt/homebrew/opt/nvm"
  _NVM_SH="/opt/homebrew/opt/nvm/nvm.sh"
elif [[ -f "/usr/local/opt/nvm/nvm.sh" ]]; then
  export NVM_DIR="/usr/local/opt/nvm"
  _NVM_SH="/usr/local/opt/nvm/nvm.sh"
else
  export NVM_DIR="${NVM_DIR:-$HOME/.config/nvm}"
  _NVM_SH="$NVM_DIR/nvm.sh"
fi

__zsh_load_nvm() {
  unset -f nvm node npm npx yarn pnpm corepack 2>/dev/null
  if [[ -s "$_NVM_SH" ]]; then
    source "$_NVM_SH"
    [[ -s "$NVM_DIR/etc/bash_completion.d/nvm" ]] && source "$NVM_DIR/etc/bash_completion.d/nvm"
  else
    return 1
  fi
}

nvm()     { __zsh_load_nvm || return $?; nvm "$@"; }
node()    { __zsh_load_nvm || return $?; command node "$@"; }
npm()     { __zsh_load_nvm || return $?; command npm "$@"; }
npx()     { __zsh_load_nvm || return $?; command npx "$@"; }
yarn()    { __zsh_load_nvm || return $?; command yarn "$@"; }
pnpm()    { __zsh_load_nvm || return $?; command pnpm "$@"; }
corepack(){ __zsh_load_nvm || return $?; command corepack "$@"; }

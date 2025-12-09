#
# nvm
#

# Allow opting out by setting ZSH_ENABLE_NVM=0 before .zshrc loads.
[[ ${ZSH_ENABLE_NVM:-1} -eq 1 ]] || return

export NVM_DIR="${NVM_DIR:-$HOME/.config/nvm}"

__zsh_load_nvm() {
  unset -f nvm node npm npx yarn pnpm corepack 2>/dev/null
  if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
  else
    return 1
  fi
}

nvm()    { __zsh_load_nvm || return $?; nvm "$@"; }
node()   { __zsh_load_nvm || return $?; command node "$@"; }
npm()    { __zsh_load_nvm || return $?; command npm "$@"; }
npx()    { __zsh_load_nvm || return $?; command npx "$@"; }
yarn()   { __zsh_load_nvm || return $?; command yarn "$@"; }
pnpm()   { __zsh_load_nvm || return $?; command pnpm "$@"; }
corepack(){ __zsh_load_nvm || return $?; command corepack "$@"; }

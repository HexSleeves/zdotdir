#
# gpg: Customize GNUPG
#

[[ -o interactive ]] && export GPG_TTY="$(tty)"
export GNUPGHOME="${GNUPGHOME:-$XDG_DATA_HOME/gnupg}"

[[ -e $GNUPGHOME:h ]] || mkdir -p -- "$GNUPGHOME:h"
alias gpg='gpg --homedir "$GNUPGHOME"'

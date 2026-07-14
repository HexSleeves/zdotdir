#
# gpg: Customize GNUPG
#

[[ -o interactive ]] && export GPG_TTY="${TTY:-$(tty 2>/dev/null)}"
export GNUPGHOME="${GNUPGHOME:-$XDG_DATA_HOME/gnupg}"

[[ -e $GNUPGHOME:h ]] || mkdir -p -- "$GNUPGHOME:h"
alias gpg='gpg --homedir "$GNUPGHOME"'

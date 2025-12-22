export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export PATH="$HOME/.local/bin:$PATH"
export VAULT_ADDR='https://vault.agro.services'

# source ~/projects/bayer-int/bayer-proxy-env/bayer-proxy-env.sh

# Editor aliases
alias idea="open -a IntelliJ\ IDEA"

export SSL_CERT_FILE="/opt/homebrew/etc/openssl@3/cert.pem"
export AWS_CA_BUNDLE="/opt/homebrew/etc/openssl@3/cert.pem"
export AWS_CA_BUNDLE="/opt/homebrew/etc/openssl@3/cert.pem"
export REQUESTS_CA_BUNDLE="/opt/homebrew/etc/openssl@3/cert.pem"
export NODE_EXTRA_CA_CERTS="$HOME/projects/bayer-int/SSL-TLS-Configuration/bayer_all.pem"

#
# tailscale
#

_TS="sudo tailscale"

alias ts="$_TS"
alias tsd="sudo tailscaled"
alias tsst="$_TS status"
alias tsup="$_TS up"
alias tsdown="$_TS down"
alias tsls="$_TS status --peers"
alias tsping="$_TS ping"
alias tsdns="$_TS dns status"
alias tsnetcheck="$_TS netcheck"
alias tswhois="$_TS whois"
alias tsbugreport="$_TS bugreport"
alias tslogs="sudo log stream --predicate 'process == \"tailscaled\"' --level debug"
alias tslogfile="tail -f /var/log/tailscaled.log"
alias tsip="$_TS ip -4"

# Peer IPv4 lookup by short hostname
tsip4() {
  local host="${1:?usage: tsip4 <hostname>}"
  sudo tailscale status --json | python3 -c "
import json,sys
d=json.load(sys.stdin)
for v in d.get('Peer',{}).values():
    if v['HostName'].lower().startswith('${host}'.lower()):
        print(v['TailscaleIPs'][0])
        break
"
}

# SSH into a peer by short hostname
tsssh() {
  local host="${1:?usage: tsssh <hostname> [user]}"
  local user="${2:-lecoqjacob}"
  local ip
  ip=$(tsip4 "$host") || return 1
  ssh "${user}@${ip}"
}

# Pretty peer table
tslsf() {
  sudo tailscale status --json | python3 -c "
import json,sys
d=json.load(sys.stdin)
fmt='%-22s %-17s %-8s %s'
print(fmt % ('HOSTNAME','IP','OS','ONLINE'))
print('-'*60)
for v in d.get('Peer',{}).values():
    ip=v['TailscaleIPs'][0] if v['TailscaleIPs'] else '-'
    print(fmt % (v['HostName'][:22], ip, v['OS'][:8], '✓' if v['Online'] else '✗'))
"
}

# Start tailscaled in background (logs to /tmp/tailscaled.log)
tsstart() {
  if pgrep -q tailscaled; then
    echo "tailscaled already running (PID $(pgrep tailscaled))"
    return
  fi
  sudo tailscaled > /tmp/tailscaled.log 2>&1 &
  echo "tailscaled started (PID $!)"
}

# Shell completion
if command -v tailscale &>/dev/null; then
  source <(tailscale completion zsh 2>/dev/null) 2>/dev/null
fi

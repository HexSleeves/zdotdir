# kpv3-cli setup
# See https://fantastic-train-o42z754.pages.github.io/#ultra-quickstart-beta

if [[ -x "$HOME/.kpv3-cli/bin/kpv3-cli" ]]; then
  eval "$($HOME/.kpv3-cli/bin/kpv3-cli source)"
  [ -s "$HOME/.kube/k8s-platform-v3" ] || kpv3-cli kubeconfig -w
fi

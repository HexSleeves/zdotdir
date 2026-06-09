# kpv3-cli setup
# See https://fantastic-train-o42z754.pages.github.io/#ultra-quickstart-beta

# Initialize kpv3-cli shell integration
eval "$($HOME/.kpv3-cli/bin/kpv3-cli source)"

# Ensure kubeconfig is present
[ -s "$HOME/.kube/k8s-platform-v3" ] || kpv3-cli kubeconfig -w

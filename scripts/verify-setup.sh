#!/bin/bash
#
# verify-setup.sh - Verify terminal optimization setup
#

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       Terminal Optimization Setup Verification        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Function to check if a command exists
check_tool() {
  local tool=$1
  local name=$2
  if command -v "$tool" &>/dev/null; then
    local version=$($tool --version 2>&1 | head -1)
    echo -e "${GREEN}✓${NC} $name"
    echo -e "  ${YELLOW}→${NC} $version"
  else
    echo -e "${RED}✗${NC} $name (not installed)"
  fi
}

# Function to check if a file exists
check_file() {
  local file=$1
  local name=$2
  if [ -f "$file" ]; then
    echo -e "${GREEN}✓${NC} $name"
  else
    echo -e "${RED}✗${NC} $name (missing)"
  fi
}

echo -e "${BLUE}[Configuration Files]${NC}"
echo ""
check_file "$HOME/.config/zsh/conf.d/modern-tools.zsh" "modern-tools.zsh"
check_file "$HOME/.config/zsh/conf.d/fzf-enhanced.zsh" "fzf-enhanced.zsh"
check_file "$HOME/.config/zsh/conf.d/performance.zsh" "performance.zsh"
check_file "$HOME/.config/zsh/conf.d/atuin.zsh" "atuin.zsh"
check_file "$HOME/.config/atuin/config.toml" "atuin config"
check_file "$HOME/.gitconfig" ".gitconfig"
check_file "$HOME/.config/tmux/tmux.conf" "tmux.conf"
echo ""

echo -e "${BLUE}[Core Modern Tools]${NC}"
echo ""
check_tool "rg" "ripgrep (fast grep)"
check_tool "fd" "fd (fast find)"
check_tool "bat" "bat (cat with syntax)"
check_tool "eza" "eza (modern ls)"
check_tool "delta" "delta (git diff viewer)"
check_tool "zoxide" "zoxide (smart cd)"
echo ""

echo -e "${BLUE}[System Tools]${NC}"
echo ""
check_tool "procs" "procs (modern ps)"
check_tool "btm" "bottom (system monitor)"
check_tool "dust" "dust (better du)"
check_tool "duf" "duf (better df)"
echo ""

echo -e "${BLUE}[Development Tools]${NC}"
echo ""
check_tool "lazygit" "lazygit (git TUI)"
check_tool "difft" "difftastic (structural diff)"
check_tool "hyperfine" "hyperfine (benchmarking)"
check_tool "tokei" "tokei (code statistics)"
echo ""

echo -e "${BLUE}[Utility Tools]${NC}"
echo ""
check_tool "atuin" "atuin (shell history)"
check_tool "tldr" "tealdeer (simplified man pages)"
check_tool "xh" "xh (better curl)"
check_tool "gping" "gping (ping with graph)"
check_tool "doggo" "doggo (better dig)"
check_tool "hexyl" "hexyl (hex viewer)"
check_tool "sd" "sd (better sed)"
check_tool "jq" "jq (JSON processor)"
check_tool "yq" "yq (YAML processor)"
check_tool "fzf" "fzf (fuzzy finder)"
echo ""

echo -e "${BLUE}[Terminal Tools]${NC}"
echo ""
check_tool "tmux" "tmux (terminal multiplexer)"
check_tool "mosh" "mosh (better ssh)"
check_tool "broot" "broot (tree navigator)"
echo ""

# Check if Xcode license is accepted
echo -e "${BLUE}[System Status]${NC}"
echo ""
if cc --version &>/dev/null 2>&1; then
  echo -e "${GREEN}✓${NC} Xcode license accepted"
else
  echo -e "${RED}✗${NC} Xcode license NOT accepted"
  echo -e "  ${YELLOW}→${NC} Run: sudo xcodebuild -license accept"
fi

if command -v brew &>/dev/null; then
  echo -e "${GREEN}✓${NC} Homebrew installed"
else
  echo -e "${RED}✗${NC} Homebrew not installed"
fi
echo ""

# Count installed vs total
TOTAL=26
INSTALLED=0
for tool in rg fd bat eza delta zoxide procs btm dust duf lazygit difft hyperfine tokei atuin tldr xh gping doggo hexyl sd jq yq fzf tmux mosh broot; do
  if command -v "$tool" &>/dev/null; then
    ((INSTALLED++))
  fi
done

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                        Summary                         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Tools Installed: ${GREEN}$INSTALLED${NC}/${TOTAL}"
echo ""

if [ $INSTALLED -eq $TOTAL ]; then
  echo -e "${GREEN}✅ All tools installed! Your terminal is fully optimized.${NC}"
  echo ""
  echo "Try these commands:"
  echo "  • lg           - Launch lazygit"
  echo "  • Ctrl+R       - Search history with atuin"
  echo "  • z <dir>      - Smart directory jump"
  echo "  • bench        - Benchmark commands"
  echo "  • help <cmd>   - Quick command examples"
else
  echo -e "${YELLOW}⚠️  Some tools are missing. Run the installation script:${NC}"
  echo "  bash ~/.config/zsh/install-tools.sh"
fi

echo ""
echo "For detailed information, see:"
echo "  cat ~/.config/zsh/OPTIMIZATION_GUIDE.md"
echo ""

#!/bin/bash
#
# install-tools.sh - Install all modern CLI tools for terminal optimization
#

set -e

echo "🚀 Modern CLI Tools Installation Script"
echo "======================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Xcode license is accepted
echo "Checking Xcode license..."
if ! cc --version &>/dev/null; then
  echo -e "${RED}❌ Xcode license not accepted!${NC}"
  echo ""
  echo "Please run the following command first:"
  echo "  sudo xcodebuild -license accept"
  echo ""
  exit 1
fi

echo -e "${GREEN}✓ Xcode license accepted${NC}"
echo ""

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
  echo -e "${RED}❌ Homebrew not found!${NC}"
  echo ""
  echo "Please install Homebrew first:"
  echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
  echo ""
  exit 1
fi

echo -e "${GREEN}✓ Homebrew found${NC}"
echo ""

# List of tools to install
TOOLS=(
  "atuin"
  "dust"
  "tealdeer"
  "duf"
  "gping"
  "lazygit"
  "difftastic"
  "tmux"
  "xh"
  "doggo"
  "hexyl"
  "mosh"
)

# Check which tools are already installed
echo "Checking which tools need to be installed..."
INSTALL_LIST=()
for tool in "${TOOLS[@]}"; do
  if command -v "$tool" &>/dev/null; then
    echo -e "${GREEN}✓${NC} $tool (already installed)"
  else
    echo -e "${YELLOW}○${NC} $tool (will be installed)"
    INSTALL_LIST+=("$tool")
  fi
done
echo ""

# Install missing tools
if [ ${#INSTALL_LIST[@]} -eq 0 ]; then
  echo -e "${GREEN}✅ All tools are already installed!${NC}"
else
  echo "Installing ${#INSTALL_LIST[@]} missing tools..."
  echo ""
  brew install "${INSTALL_LIST[@]}"
  echo ""
  echo -e "${GREEN}✅ Installation complete!${NC}"
fi

# Update tldr cache
if command -v tldr &>/dev/null; then
  echo ""
  echo "Updating tldr cache..."
  tldr --update
  echo -e "${GREEN}✓ tldr cache updated${NC}"
fi

# Initialize atuin
if command -v atuin &>/dev/null; then
  if [ ! -f "$HOME/.local/share/atuin/history.db" ]; then
    echo ""
    echo "Initializing atuin..."
    echo "Importing existing shell history..."
    atuin import auto
    echo -e "${GREEN}✓ Atuin initialized${NC}"
  else
    echo -e "${GREEN}✓ Atuin already initialized${NC}"
  fi
fi

# Final summary
echo ""
echo "======================================="
echo -e "${GREEN}🎉 Installation Complete!${NC}"
echo "======================================="
echo ""
echo "Next steps:"
echo "  1. Reload your shell: exec zsh"
echo "  2. Read the optimization guide: cat ~/.config/zsh/OPTIMIZATION_GUIDE.md"
echo "  3. Configure git user info:"
echo "     git config --global user.name \"Your Name\""
echo "     git config --global user.email \"your.email@example.com\""
echo ""
echo "Try these commands:"
echo "  • lg           - Launch lazygit"
echo "  • Ctrl+R       - Search history with atuin"
echo "  • z <dir>      - Smart directory jump with zoxide"
echo "  • bench        - Benchmark commands with hyperfine"
echo "  • help <cmd>   - Quick command examples with tldr"
echo ""
echo "For more info, see: ~/.config/zsh/OPTIMIZATION_GUIDE.md"
echo ""

#!/usr/bin/env bash
set -euo pipefail

# Claude Code Environment Installer
# Sets up Claude Code with all plugins, hooks, and configs on a fresh machine.
# Usage: bash install.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Claude Code Environment Setup ==="
echo ""

# --- 1. Install nvm + Node 22 ---
echo "[1/6] Installing nvm and Node.js 22..."
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    echo "  nvm already installed, skipping."
else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

if node --version 2>/dev/null | grep -q "^v2[2-9]\|^v[3-9]"; then
    echo "  Node $(node --version) already installed."
else
    nvm install 22
fi

echo "  Node $(node --version) ready."
echo ""

# --- 2. Git identity ---
echo "[2/6] Configuring git identity..."
git config --global user.name "Yipeng Li"
git config --global user.email "y9li@ucsd.edu"

# Set up gh credential helper if gh is available
if command -v gh &>/dev/null; then
    git config --global credential.https://github.com.helper ""
    git config --global credential.https://github.com.helper "!/usr/bin/gh auth git-credential"
    git config --global credential.https://gist.github.com.helper ""
    git config --global credential.https://gist.github.com.helper "!/usr/bin/gh auth git-credential"
    echo "  Git identity and GitHub credential helper configured."
else
    echo "  Git identity configured. (Install gh CLI separately for credential helper)"
fi
echo ""

# --- 3. Install Claude Code (if not installed) ---
echo "[3/6] Checking Claude Code..."
if command -v claude &>/dev/null; then
    echo "  Claude Code already installed."
else
    echo "  Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code
fi
echo ""

# --- 4. Deploy Claude Code settings ---
echo "[4/6] Deploying Claude Code settings..."
mkdir -p "$HOME/.claude"

cp "$SCRIPT_DIR/configs/settings.json" "$HOME/.claude/settings.json"
echo "  settings.json deployed."

# Deploy memory files
MEMORY_DIR="$HOME/.claude/projects/-home-$(whoami)/memory"
mkdir -p "$MEMORY_DIR"
cp "$SCRIPT_DIR/configs/memory/MEMORY.md" "$MEMORY_DIR/MEMORY.md"
cp "$SCRIPT_DIR/configs/memory/feedback_git_identity.md" "$MEMORY_DIR/feedback_git_identity.md"
echo "  Memory files deployed."
echo ""

# --- 5. Install claude-mem ---
echo "[5/6] Installing claude-mem..."
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

npx claude-mem install
echo ""

# Deploy claude-mem settings (overwrite defaults with our config)
echo "  Deploying claude-mem settings..."
mkdir -p "$HOME/.claude-mem"
cp "$SCRIPT_DIR/configs/claude-mem/settings.json" "$HOME/.claude-mem/settings.json"
# Fix DATA_DIR path for current user
sed -i "s|/home/exx|$HOME|g" "$HOME/.claude-mem/settings.json"
echo "  claude-mem settings deployed."
echo ""

# --- 6. Start claude-mem worker ---
echo "[6/6] Starting claude-mem worker..."
npx claude-mem start || echo "  (Worker may need manual start after restarting terminal)"
echo ""

echo "=== Setup Complete ==="
echo ""
echo "Summary:"
echo "  - Node.js $(node --version) via nvm"
echo "  - Git: Yipeng Li <y9li@ucsd.edu>"
echo "  - Claude Code: settings + hooks deployed"
echo "  - claude-mem: installed and running"
echo ""
echo "Next steps:"
echo "  1. Authenticate Claude Code:  claude auth"
echo "  2. Authenticate GitHub CLI:   gh auth login"
echo "  3. Restart your terminal (or run: source ~/.bashrc)"
echo "  4. Start coding!"

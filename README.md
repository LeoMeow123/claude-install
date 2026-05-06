# claude-install

Automated setup for my Claude Code environment. Run one script to get a fully configured Claude Code instance with plugins, hooks, git identity, and persistent memory on any new machine.

## What's Included

| Component | Description |
|-----------|-------------|
| **Zellij** | Terminal multiplexer with custom navy-blue theme and vim/tmux keybinds |
| **Node.js 22** | Installed via nvm (required by claude-mem) |
| **Git identity** | `Yipeng Li <y9li@ucsd.edu>` + GitHub credential helper |
| **Claude Code settings** | Model (Opus 4.6), theme, effort level, permissions |
| **Git commit hook** | Blocks Co-Authored-By lines, enforces git identity on every commit |
| **claude-mem** | Persistent memory plugin - captures session context and injects it into future sessions |
| **Memory files** | Pre-configured feedback/preferences for Claude behavior |

## Quick Start

```bash
# 1. Clone this repo
git clone https://github.com/LeoMeow123/claude-install.git
cd claude-install

# 2. Run the installer
bash install.sh

# 3. Authenticate (first time only)
claude auth
gh auth login
```

That's it. Restart your terminal and start using Claude Code.

## Prerequisites

- **OS**: Ubuntu/Debian Linux (tested on Ubuntu 22.04+)
- **curl**: For downloading nvm
- **sudo access**: Not required (everything installs to user home)

The script will install everything else automatically (nvm, Node.js, Claude Code, claude-mem, Bun).

## What the Installer Does

```
install.sh
├── [1] Install zellij + deploy config (skips install if already present)
├── [2] Install nvm + Node.js 22 (skips if already present)
├── [3] Configure git identity (name, email, credential helper)
├── [4] Install Claude Code CLI (skips if already present)
├── [5] Deploy settings.json + memory files to ~/.claude/
├── [6] Install claude-mem plugin
└── [7] Start claude-mem worker service
```

## File Structure

```
claude-install/
├── install.sh                        # Main installer script
├── README.md                         # This file
└── configs/
    ├── settings.json                 # Claude Code settings + hooks
    ├── zellij/
    │   └── config.kdl                # Zellij terminal multiplexer config
    ├── claude-mem/
    │   └── settings.json             # claude-mem plugin configuration
    └── memory/
        ├── MEMORY.md                 # Memory index
        └── feedback_git_identity.md  # Git identity preference
```

## Configuration Details

### Zellij (`configs/zellij/config.kdl`)

- **Theme**: `navy-blue` (custom dark theme)
- **Keybinds**: `clear-defaults=true` with vim-style navigation (hjkl)
- **Tmux compatibility**: `Ctrl b` prefix mode with familiar tmux bindings
- **Modes**: pane, tab, resize, move, scroll, search, session management

### Claude Code Settings (`configs/settings.json`)

- **Model**: `claude-opus-4-6`
- **Effort**: `high`
- **Theme**: `dark`
- **Auto-compact**: disabled
- **Auto-updates**: latest channel

### Git Commit Hook

A `PreToolUse` hook that fires before every `git commit`:
1. Sets `user.name` and `user.email` to ensure correct authorship
2. Blocks any commit message containing `Co-Authored-By` (keeps commits looking human)

### claude-mem Plugin

Persistent memory system that:
- Automatically captures tool usage during coding sessions
- Compresses observations with AI
- Injects relevant context into future sessions
- Web viewer at `http://localhost:37700`

## Updating

When you change settings on your main machine:

```bash
# Copy updated configs back to the repo
cp ~/.config/zellij/config.kdl configs/zellij/config.kdl
cp ~/.claude/settings.json configs/settings.json
cp ~/.claude-mem/settings.json configs/claude-mem/settings.json

# Commit and push
git add -A && git commit -m "update configs"
git push
```

On other machines, pull and re-run:

```bash
cd claude-install
git pull
bash install.sh
```

## Troubleshooting

### claude-mem worker won't start
```bash
# Restart your terminal first, then:
source ~/.bashrc
npx claude-mem start
```

### Node version issues
```bash
source ~/.nvm/nvm.sh
nvm use 22
```

### Resetting everything
```bash
rm -rf ~/.claude/settings.json ~/.claude-mem
bash install.sh
```

## License

MIT

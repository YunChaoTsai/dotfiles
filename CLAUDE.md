# Dotfiles Installation Guide

This is a dotfiles repository. When asked to apply or install these dotfiles, follow the instructions below.

## Available Dotfiles

| Source | Target | Description |
|--------|--------|-------------|
| `.gitignore` | `~/.gitignore` | Global gitignore (macOS, VSCode) |
| `.claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | Claude Code global instructions |
| `claude-statusline/` | `~/.claude/` | Go-based status line (model, context, git branch, session time) |

## Installation Steps

1. **Global gitignore**: Copy and configure git
   ```bash
   ln -sf .gitignore ~/.gitignore
   git config --global core.excludesfile ~/.gitignore
   ```

2. **CLAUDE.md**: Copy to user's Claude config
   ```bash
   ln -sf .claude/CLAUDE.md ~/.claude/CLAUDE.md
   ```

3. **Claude Statusline**: Run the install script
   ```bash
   cd claude-statusline && ./install.sh
   ```
   This will:
   - Copy and compile `statusline.go` to `~/.claude/statusline-go`
   - Copy `claude-stats.sh` to `~/.claude/`
   - Create required directories
   - Update `~/.claude/settings.json` with statusLine config

## Prerequisites

- Go 1.19+ and `jq` are required
  ```bash
  brew install go jq  # macOS
  ```

## Notes

- Always ask before overwriting existing files
- Show diff if target file already exists

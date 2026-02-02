# dotfiles

Personal configuration files.

## Quick Start with Claude Code

The easiest way to apply these dotfiles is using [Claude Code](https://claude.ai/claude-code):

```bash
cd ~/Documents/projects/dotfiles  # or wherever you cloned this repo
claude
```

Then ask:

> Apply these dotfiles to my system

## Contents

| Path | Description |
|------|-------------|
| `.gitignore` | Global gitignore (macOS, VSCode, local files) |
| `.claude/CLAUDE.md` | Claude Code global instructions and preferences |
| `claude-statusline/` | Go-based status line with install script and stats tool |

## Claude Statusline

Custom status line for Claude Code showing:
- **Model**: Opus 💛 / Sonnet 💠 / Haiku 🌸 with color coding
- **Project**: Current working directory
- **Git branch**: With 5-second cache optimization
- **Context usage**: Color progress bar + percentage + token count
- **Session time**: Auto-tracked across multiple sessions

Preview:
```
[💛 Claude Opus 4.5] 📂 my-project ⚡ main | ██████░░░░ 58% 116k | 2h35m
```

**Quick install:**
```bash
cd claude-statusline && ./install.sh
```

See [claude-statusline/README.md](claude-statusline/README.md) for detailed setup.

## Manual Installation

See [CLAUDE.md](CLAUDE.md) for detailed installation steps.

**Prerequisites:** Go 1.19+, [jq](https://jqlang.github.io/jq/) (`brew install go jq` on macOS)

## License

[MIT](LICENSE)

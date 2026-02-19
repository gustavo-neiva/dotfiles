# Dotfiles

Personal configuration files for portable development environment setup.

## Prerequisites

Ensure these tools are installed before using these dotfiles:

- **Homebrew** - Package manager for macOS
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```

- **Zsh** - Shell (usually pre-installed on macOS)

- **Oh-my-zsh** - Zsh configuration framework
  ```bash
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ```

- **Ghostty** - Modern terminal emulator
  ```bash
  brew install --cask ghostty
  ```

- **Zed** - Code editor
  ```bash
  brew install --cask zed
  ```

- **Claude Code** - AI coding assistant
  ```bash
  npm install -g @anthropic-ai/claude-code
  ```

## Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/gustavo-neiva/dotfiles.git ~/Code/gustavo-neiva/dotfiles
   cd ~/Code/gustavo-neiva/dotfiles
   ```

2. **Run the installation script**
   ```bash
   ./install.sh
   ```

   The script will:
   - Create backups of existing dotfiles with timestamp
   - Display the symlink commands to run manually
   - Show commands to clone external zsh plugins from their original repos
   - **NOT** overwrite any existing files (backup-only mode)

3. **Create the symlinks** (run the commands shown by the script)

4. **Edit API tokens** in `~/.zshrc`:
   ```bash
   # Replace placeholder values with your actual tokens
   export ZAI_TOKEN="your-zai-token-here"
   export CONTEXT7_API_KEY="your-context7-api-key-here"
   ```

5. **Reload your shell**
   ```bash
   source ~/.zshrc
   # Or open a new terminal window
   ```

## Folder Structure

```
dotfiles/
├── .gitignore                    # Exclude sensitive/temporary files
├── README.md                     # This file
├── install.sh                    # Bootstrap script
├── home/                         # Files that go to ~/
│   └── .zshrc                    # Main zsh configuration
├── config/                       # Files that go to ~/.config/
│   ├── zed/
│   │   └── settings.json         # Zed editor settings
│   ├── git/
│   │   └── ignore                # Global gitignore
│   └── ghostty/
│       └── config                # Ghostty terminal config
├── oh-my-zsh/                    # Custom oh-my-zsh additions
│   └── custom/
│       └── plugins/
│           └── colors/           # Custom color helpers for zsh
└── claude/                       # Claude Code configuration
    ├── settings.json             # Claude Code settings
    ├── CLAUDE.md                 # Global instructions for Claude
    ├── hooks/                    # Custom hooks (statusline)
    └── skills/                   # Custom Claude Code skills
        ├── capture-learnings/
        ├── context7/
        └── session-context-snapshots/
```

## Configuration Details

### Zsh (.zshrc)

- **Theme**: robbyrussell (default oh-my-zsh)
- **Plugins**: git, colors, zsh-autosuggestions, zsh-syntax-highlighting
- **Custom Functions**:
  - `ccz` - Run Claude Code with Z.ai API
  - `cca` - Run Claude Code with standard Anthropic API

### Zed Editor

- Font: Menlo
- Theme: One Dark Pro (dark), One Light (light)
- Keymap: VSCode
- Ruby LSP integration with rubocop

### Ghostty Terminal

- Theme: Pro
- Background opacity: 0.9
- Cursor: Block (blinking)
- Shell integration enabled

### Claude Code

- Model preference: Opus
- Custom statusline hook (robbyrussell-inspired)
- Custom skills for documentation lookup and session management

## Manual Setup Steps

### API Tokens

After installation, edit `~/.zshrc` and replace these placeholders:

```bash
# Z.ai API token (for ccz function)
export ZAI_TOKEN="your-zai-token-here"

# Context7 API key
export CONTEXT7_API_KEY="your-context7-api-key-here"
```

### Conda (Optional)

If you use Anaconda/Miniconda, uncomment the conda section in `~/.zshrc`.

### OpenClaw (Optional)

If you use OpenClaw, uncomment the OpenClaw completion section in `~/.zshrc`.

## Restoring Backups

If something goes wrong, backups are created with timestamps:

```bash
# Restore a specific backup
mv ~/.zshrc.backup.20250218_143022 ~/.zshrc

# List all backups
ls -la ~/*.backup.*
```

## Updating

To update the dotfiles repository and external plugins:

```bash
# Update dotfiles
cd ~/Code/gustavo-neiva/dotfiles
git pull origin main

# Update external zsh plugins (cloned from original repos)
cd ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && git pull
cd ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && git pull
```

## Machine-Specific Notes

- **macOS**: Ghostty config is in `~/Library/Application Support/com.mitchellh.ghostty/`
- **Linux**: Ghostty config is in `~/.config/ghostty/`

The install script detects the OS and handles paths accordingly.

## License

MIT

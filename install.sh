#!/usr/bin/env bash
# Dotfiles Installation Script
# Mode: Backup-only - creates backups and provides manual symlink commands
# Usage: ./install.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DATE=$(date +%Y%m%d_%H%M%S)

echo -e "${BLUE}=== Dotfiles Installation Script ===${NC}"
echo -e "${BLUE}Dotfiles directory:${NC} $DOTFILES_DIR"
echo -e "${BLUE}Backup suffix:${NC} .backup.$BACKUP_DATE"
echo ""

# Function to backup file if it exists
backup_file() {
    local src="$1"
    if [ -e "$src" ]; then
        local backup="${src}.backup.${BACKUP_DATE}"
        echo -e "${YELLOW}Backing up:${NC} $src -> $backup"
        cp -R "$src" "$backup"
        return 0
    else
        echo -e "${GREEN}No existing file:${NC} $src (will create new)"
        return 1
    fi
}

# Function to show symlink command
show_link() {
    local src="$1"
    local dest="$2"
    local relative_path="${dest#$HOME/}"
    echo -e "  ${BLUE}ln -s${NC} \"$DOTFILES_DIR/$relative_path\" \"$src\""
}

# Detect OS
OS="$(uname -s)"
echo -e "${BLUE}Detected OS:${NC} $OS"
echo ""

# ============================================
# Home directory files (~/)
# ============================================
echo -e "${BLUE}=== Home Directory Files ===${NC}"

home_files=(
    ".zshrc"
    ".zprofile"
    ".gitignore"
    ".tool-versions"
    ".asdfrc"
)

for file in "${home_files[@]}"; do
    target="$HOME/$file"
    source="$DOTFILES_DIR/home/$file"

    if [ -f "$source" ]; then
        backup_file "$target" || true
        show_link "$target" "$source"
    fi
done
echo ""

# ============================================
# Config files (~/.config/)
# ============================================
echo -e "${BLUE}=== Config Directory Files ===${NC}"

# Zed
if [ -f "$DOTFILES_DIR/config/zed/settings.json" ]; then
    target="$HOME/.config/zed/settings.json"
    source="$DOTFILES_DIR/config/zed/settings.json"
    backup_file "$target" || true
    show_link "$target" "$source"
fi

# Git
if [ -f "$DOTFILES_DIR/config/git/ignore" ]; then
    target="$HOME/.config/git/ignore"
    source="$DOTFILES_DIR/config/git/ignore"
    backup_file "$target" || true
    show_link "$target" "$source"
fi

echo ""

# ============================================
# Ghostty config (OS-specific)
# ============================================
echo -e "${BLUE}=== Ghostty Terminal Config ===${NC}"

if [ "$OS" = "Darwin" ]; then
    # macOS
    ghostty_config_dir="$HOME/Library/Application Support/com.mitchellh.ghostty"
elif [ "$OS" = "Linux" ]; then
    # Linux
    ghostty_config_dir="$HOME/.config/ghostty"
else
    echo -e "${YELLOW}Unknown OS for Ghostty config${NC}"
    ghostty_config_dir=""
fi

if [ -n "$ghostty_config_dir" ] && [ -f "$DOTFILES_DIR/config/ghostty/config" ]; then
    target="$ghostty_config_dir/config"
    source="$DOTFILES_DIR/config/ghostty/config"
    mkdir -p "$ghostty_config_dir"
    backup_file "$target" || true
    show_link "$target" "$source"
fi
echo ""

# ============================================
# Oh-my-zsh custom plugins
# ============================================
echo -e "${BLUE}=== Oh-my-zsh Custom Plugins ===${NC}"

custom_plugins=(
    "colors"
)

for plugin in "${custom_plugins[@]}"; do
    target="$HOME/.oh-my-zsh/custom/plugins/$plugin"
    source="$DOTFILES_DIR/oh-my-zsh/custom/plugins/$plugin"

    if [ -d "$source" ]; then
        if [ -d "$target" ]; then
            backup_file "$target" || true
        else
            echo -e "${GREEN}No existing plugin:${NC} $target (will create new)"
        fi
        show_link "$target" "$source"
    fi
done

echo ""

# ============================================
# External oh-my-zsh plugins (cloned from original repos)
# ============================================
echo -e "${BLUE}=== External Oh-my-zsh Plugins ===${NC}"

# Define external plugins
declare -A external_plugins=(
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
)

for plugin_name in "${!external_plugins[@]}"; do
    plugin_url="${external_plugins[$plugin_name]}"
    target_dir="$HOME/.oh-my-zsh/custom/plugins/$plugin_name"

    if [ -d "$target_dir" ]; then
        echo -e "${YELLOW}Plugin exists:${NC} $plugin_name (will update)"
        echo -e "  ${BLUE}cd \"$target_dir\" && git pull${NC}"
    else
        echo -e "${GREEN}Cloning:${NC} $plugin_name"
        echo -e "  ${BLUE}git clone \"$plugin_url\" \"$target_dir\"${NC}"
    fi
done
echo ""

# ============================================
# Claude Code configuration
# ============================================
echo -e "${BLUE}=== Claude Code Configuration ===${NC}"

claude_files=(
    "settings.json"
    "CLAUDE.md"
    "hooks/statusline.sh"
)

for file in "${claude_files[@]}"; do
    target="$HOME/.claude/$file"
    source="$DOTFILES_DIR/claude/$file"

    if [ -e "$source" ]; then
        # Create parent directory if needed
        target_dir=$(dirname "$target")
        if [ ! -d "$target_dir" ]; then
            mkdir -p "$target_dir"
            echo -e "${GREEN}Created directory:${NC} $target_dir"
        fi

        backup_file "$target" || true
        show_link "$target" "$source"
    fi
done

# Custom skills
if [ -d "$DOTFILES_DIR/claude/skills" ]; then
    echo ""
    echo -e "${BLUE}Custom Claude Code skills (copy to ~/.claude/skills/):${NC}"
    for skill_dir in "$DOTFILES_DIR/claude/skills"/*; do
        if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")
            target="$HOME/.claude/skills/$skill_name"
            echo -e "  ${BLUE}cp -r${NC} \"$skill_dir\" \"$target\""
        fi
    done
fi
echo ""

# ============================================
# Manual setup reminders
# ============================================
echo -e "${BLUE}=== Manual Setup Required ===${NC}"
echo -e "${YELLOW}1. API Tokens:${NC} Edit ~/.zshrc and add your actual tokens:"
echo -e "   - ZAI_TOKEN (for ccz function)"
echo -e "   - CONTEXT7_API_KEY"
echo ""
echo -e "${YELLOW}2. Create symlinks:${NC} Run the commands above to link the files"
echo ""
echo -e "${YELLOW}3. Reload shell:${NC} Run 'source ~/.zshrc' or open a new terminal"
echo ""

# ============================================
# Summary
# ============================================
echo -e "${GREEN}=== Installation Complete ===${NC}"
echo -e "${GREEN}All existing files have been backed up with suffix .backup.${BACKUP_DATE}${NC}"
echo -e "${YELLOW}To restore backups if needed:${NC}"
echo -e "  ${BLUE}mv ~/.zshrc.backup.${BACKUP_DATE} ~/.zshrc${NC}"
echo ""

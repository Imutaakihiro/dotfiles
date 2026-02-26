#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ==================================================
# Homebrew
# ==================================================
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # アーキテクチャに応じてパスを設定
    if [[ -f /opt/homebrew/bin/brew ]]; then
        # Apple Silicon
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        # Intel Mac
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

brew bundle --file="$DOTFILES_DIR/Brewfile"

# ==================================================
# mise（グローバル Python）
# ==================================================
mise trust "$DOTFILES_DIR/.config/mise/config.toml"
eval "$(mise activate bash)"
mise install

# ==================================================
# uv（グローバル CLI ツール）
# ==================================================
if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

if [ -f "$DOTFILES_DIR/.config/uv/uv-tools.txt" ]; then
    while IFS= read -r tool || [ -n "$tool" ]; do
        [[ "$tool" =~ ^#.*$ || -z "$tool" ]] && continue
        echo "Installing $tool..."
        uv tool install "$tool"
    done < "$DOTFILES_DIR/.config/uv/uv-tools.txt"
fi

# Playwright ブラウザのインストール
if command -v playwright &> /dev/null; then
    echo "Installing Playwright browsers..."
    playwright install chromium
fi

# ==================================================
# Claude Code
# ==================================================
if ! command -v claude &> /dev/null; then
    echo "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
fi

# ==================================================
# Google Cloud SDK
# ==================================================
if ! command -v gcloud &> /dev/null && [ ! -d "$HOME/google-cloud-sdk" ]; then
    echo "Installing Google Cloud SDK..."
    export CLOUDSDK_CORE_DISABLE_PROMPTS=1
    curl https://sdk.cloud.google.com | bash
fi

# ==================================================
# 設定ファイル（シンボリックリンク）
# ==================================================
ln -sf "$DOTFILES_DIR/.gitconfig" ~/.gitconfig
ln -sf "$DOTFILES_DIR/.zprofile" ~/.zprofile
ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc

mkdir -p ~/.config/mise
ln -sf "$DOTFILES_DIR/.config/mise/config.toml" ~/.config/mise/config.toml

mkdir -p ~/.config/uv
ln -sf "$DOTFILES_DIR/.config/uv/uv.toml" ~/.config/uv/uv.toml

mkdir -p ~/.config/zellij/layouts
ln -sf "$DOTFILES_DIR/.config/zellij/config.kdl" ~/.config/zellij/config.kdl
ln -sf "$DOTFILES_DIR/.config/zellij/layouts/default.kdl" ~/.config/zellij/layouts/default.kdl
ln -sf "$DOTFILES_DIR/.config/zellij/layouts/tmp.kdl" ~/.config/zellij/layouts/tmp.kdl

mkdir -p ~/.config/ghostty
ln -sf "$DOTFILES_DIR/.config/ghostty/config" ~/.config/ghostty/config
ln -sf "$DOTFILES_DIR/.config/ghostty/bg.jpg" ~/.config/ghostty/bg.jpg

ln -sf "$DOTFILES_DIR/.config/starship.toml" ~/.config/starship.toml

mkdir -p ~/.config/git
ln -sf "$DOTFILES_DIR/.config/git/ignore" ~/.config/git/ignore

# raycast script-commandsはディレクトリ全体をシンボリックリンク
if [ -d ~/.config/raycast/script-commands ] && [ ! -L ~/.config/raycast/script-commands ]; then
    rm -rf ~/.config/raycast/script-commands
fi
mkdir -p ~/.config/raycast
ln -sfn "$DOTFILES_DIR/.config/raycast/script-commands" ~/.config/raycast/script-commands

# nvimはディレクトリ全体をシンボリックリンク
if [ -d ~/.config/nvim ] && [ ! -L ~/.config/nvim ]; then
    rm -rf ~/.config/nvim
fi
ln -sfn "$DOTFILES_DIR/.config/nvim" ~/.config/nvim

# Claude Code設定（ファイル単位でリンク、他のファイルは残す）
mkdir -p ~/.claude/sounds
ln -sf "$DOTFILES_DIR/.claude/CLAUDE.md" ~/.claude/CLAUDE.md
ln -sf "$DOTFILES_DIR/.claude/settings.json" ~/.claude/settings.json
ln -sf "$DOTFILES_DIR/.claude/statusline.sh" ~/.claude/statusline.sh
ln -sfn "$DOTFILES_DIR/.claude/scripts" ~/.claude/scripts

# skillsはディレクトリ全体をシンボリックリンク
if [ -d ~/.claude/skills ] && [ ! -L ~/.claude/skills ]; then
    rm -rf ~/.claude/skills
fi
ln -sfn "$DOTFILES_DIR/.claude/skills" ~/.claude/skills

ln -sf "$DOTFILES_DIR/.claude/sounds/complete.wav" ~/.claude/sounds/complete.wav
ln -sf "$DOTFILES_DIR/.claude/sounds/confirm.wav" ~/.claude/sounds/confirm.wav

echo "Setup complete! Run 'source ~/.zshrc' to apply changes."

# ==================================================
# mise（グローバル Python）
# ==================================================
eval "$(mise activate zsh)"

# ==================================================
# Google Cloud SDK（補完）
# ==================================================
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# ==================================================
# プラグイン
# ==================================================
# コマンド入力時に履歴から補完候補を表示
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# ファジーファインダー（Ctrl+Rで履歴検索など）
source $(brew --prefix)/opt/fzf/shell/completion.zsh
source $(brew --prefix)/opt/fzf/shell/key-bindings.zsh
# ターミナル起動時に入力メソッドを英数に切り替え
macism com.apple.keylayout.ABC

# ==================================================
# プロンプト（Starship）
# ==================================================
eval "$(starship init zsh)"

# ==================================================
# direnv（ディレクトリごとの環境変数管理）
# NOTE: 他のシェル拡張（starship等）の後に置くこと
#       https://direnv.net/docs/hook.html
# ==================================================
eval "$(direnv hook zsh)"

# ==================================================
# その他の設定
# ==================================================
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt correct

# ==================================================
# エイリアス
# ==================================================
alias vim='nvim'
alias dbtf="$HOME/.local/bin/dbt"

# ==================================================
# カスタム関数
# ==================================================
# 指定ディレクトリで Nvim + Claude Code の Zellij タブを開く
# Usage: ztmp [dir]  (省略時はカレントディレクトリ)
ztmp() {
  zellij action new-tab --layout ~/.config/zellij/layouts/tmp.kdl --cwd "${1:-.}" --name "tmp"
}

# ==================================================
# 業務ツール
# ==================================================
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$PATH:$HOME/.turso"

# ==================================================
# Zellij自動起動（Ghostty使用時のみ）
# ==================================================
if [[ "$TERM" == "xterm-ghostty" ]] && [[ -z "$ZELLIJ" ]]; then
  zellij
fi

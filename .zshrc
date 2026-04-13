# ==================================================
# mise（ランタイムバージョン管理）
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
# ファジーファインダー（Ctrl+R で履歴検索・Ctrl+T でファイル検索）
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
# NOTE: 他のシェル拡張（starship 等）の後に置くこと
#       https://direnv.net/docs/hook.html
# ==================================================
eval "$(direnv hook zsh)"

# ==================================================
# 履歴設定
# ==================================================
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt share_history          # ターミナル間で履歴を共有
setopt hist_ignore_all_dups   # 重複したコマンドを記録しない
setopt hist_reduce_blanks     # 余分な空白を除いて記録
setopt correct                # タイプミスを自動修正

# ==================================================
# エイリアス
# ==================================================
alias vim='nvim'
alias v='nvim'
alias g='git'
alias ll='ls -la'
alias la='ls -a'

# ==================================================
# Ghostty ヘルパー関数
# ==================================================
## gdev: 指定ディレクトリで垂直分割（左: nvim, 右: Claude Code）
## 実装は bin/gdev を参照
source "$HOME/.local/bin/gdev"

# ==================================================
# gcloud 切り替え
# ==================================================
## gswitch: gcloud configuration + ADC を一括切り替え
## gswitch-setup: 新規 configuration の作成
source "$HOME/.local/bin/gswitch"

#!/bin/bash
#
# macOS defaults settings
# Run: ./macos.sh
#
# Note: Some changes require logout/restart to take effect
#

set -e

echo "Applying macOS defaults..."

# ==================================================
# Dock
# ==================================================

# Dock の位置 (left, bottom, right)
defaults write com.apple.dock orientation -string "right"

# Dock を自動的に隠す
defaults write com.apple.dock autohide -bool true

# Dock の表示/非表示の遅延をなくす
defaults write com.apple.dock autohide-delay -float 0

# Dock のアイコンサイズ (px)
defaults write com.apple.dock tilesize -int 40

# 最近使ったアプリを Dock に表示しない
defaults write com.apple.dock show-recents -bool false

# Dock の出現アニメーション速度 (デフォルト0.7、0で即時)
defaults write com.apple.dock autohide-time-modifier -float 0.3

# 最小化時にアプリアイコンに格納
defaults write com.apple.dock minimize-to-application -bool true

# アプリ起動時のバウンドアニメーションを無効
defaults write com.apple.dock launchanim -bool false

# ==================================================
# Appearance
# ==================================================

# ダークモードを有効化
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# ==================================================
# Finder
# ==================================================

# 全ての拡張子を表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# 隠しファイルを表示
defaults write com.apple.finder AppleShowAllFiles -bool true

# パスバーを表示
defaults write com.apple.finder ShowPathbar -bool true

# ステータスバーを表示
defaults write com.apple.finder ShowStatusBar -bool true

# デフォルトの表示形式をカラム表示に (icnv=アイコン, clmv=カラム, Flwv=ギャラリー, Nlsv=リスト)
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# フォルダを常に先頭に表示
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# 拡張子変更時の警告を無効化
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# 新規ウィンドウのデフォルトを Downloads に
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Downloads/"

# ==================================================
# Keyboard
# ==================================================

# キーリピートを速く (システム環境設定の最速は2)
defaults write NSGlobalDomain KeyRepeat -int 2

# キーリピート開始までの時間を短く (システム環境設定の最速は15)
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# 長押しで特殊文字ではなくキーリピート
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# F1、F2などを標準のファンクションキーとして使用
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# Raycast 等の他ランチャーに割り当てるため、デフォルトのショートカットキーを無効にする
# Command+Space
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
# Command+Option+Space
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:65:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# CleanShot X を使うため、デフォルトのスクリーンショットショートカットを無効にする
# Cmd+Shift+3: 画面のピクチャをファイルとして保存
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:28:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
# Cmd+Ctrl+Shift+3: 画面のピクチャをクリップボードにコピー
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:29:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
# Cmd+Shift+4: 選択部分のピクチャをファイルとして保存
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:30:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
# Cmd+Ctrl+Shift+4: 選択部分のピクチャをクリップボードにコピー
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:31:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
# Cmd+Shift+5: スクリーンショットと収録のオプション
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:184:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# ==================================================
# Text Input
# ==================================================

# 自動大文字を無効化
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# スペル自動修正を無効化
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# スマート引用符を無効化 ("" → "")
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# スマートダッシュを無効化 (-- → —)
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# ピリオド2回で置換を無効化 (.. → . )
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# ==================================================
# Trackpad
# ==================================================

# トラッキング速度 (0-3, 大きいほど速い。システム設定の最速は3)
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 3

# タップでクリック
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# 3本指ドラッグを有効化
# Dragging: 0=無効, 1=ドラッグロックなし, 2=ドラッグロックあり
defaults write com.apple.AppleMultitouchTrackpad Dragging -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# 3本指ジェスチャーを無効化（3本指ドラッグと競合するため）
# 代わりに4本指でMission Control等を操作
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0

# 2本指で右クリック
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true

# ナチュラルスクロール
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# ==================================================
# Mouse
# ==================================================

# スクロール速度 (0-5, 大きいほど速い)
defaults write NSGlobalDomain com.apple.scrollwheel.scaling -float 5

# ==================================================
# Hot Corners
# ==================================================
# 値: 0=無効, 2=Mission Control, 3=アプリケーションウィンドウ,
#     4=デスクトップ, 5=スクリーンセーバー開始, 6=スクリーンセーバー無効,
#     10=ディスプレイをスリープ, 11=Launchpad, 12=通知センター

# 左下: スクリーンセーバー開始
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0

# ==================================================
# Screenshot
# ==================================================

# スクリーンショットの保存場所
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

# ==================================================
# Menu Bar
# ==================================================

# バッテリー残量を%表示
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Bluetooth をメニューバーに表示
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true

# ==================================================
# Misc
# ==================================================

# .DS_Store をネットワークドライブに作成しない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# .DS_Store を USB ドライブに作成しない
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ==================================================
# TextEdit
# ==================================================

# デフォルトをプレーンテキストに
defaults write com.apple.TextEdit RichText -int 0

# ==================================================
# Apply changes
# ==================================================

# スクリーンショットフォルダを作成
mkdir -p "${HOME}/Pictures/Screenshots"

# フォルダ名を英語表示に（.localized を削除）
rm -f ~/Desktop/.localized
rm -f ~/Downloads/.localized
rm -f ~/Documents/.localized
rm -f ~/Pictures/.localized
rm -f ~/Music/.localized
rm -f ~/Movies/.localized
rm -f ~/Public/.localized
rm -f ~/Library/.localized
rm -f ~/Applications/.localized

# システムフォルダの英語表示（sudo 必要）
sudo rm -f /Applications/.localized
sudo rm -f /Library/.localized

# 設定を反映するためにプロセスを再起動
killall Dock
killall Finder
killall SystemUIServer

echo "Done!"
echo ""
echo "Note: Some settings (Keyboard, Trackpad, etc.) require a restart to take effect."
echo "Please restart your Mac to apply all changes."

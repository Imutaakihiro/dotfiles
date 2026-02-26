#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Delete Screenshot
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🗑️

# Documentation:
# @raycast.description スクリーンショットを全て削除する。
# @raycast.author tanuuuuuuu
# @raycast.authorURL https://raycast.com/tanuuuuuuu

# documents/screenshot ディレクトリのパス
screenshot_dir="$HOME/documents/screenshot"

# ディレクトリが存在するかチェック
if [ ! -d "$screenshot_dir" ]; then
  printf "エラー: ディレクトリ '%s' が存在しません" "$screenshot_dir"
  exit 1
fi

# ディレクトリ内のファイル数をカウント
file_count=$(find "$screenshot_dir" -type f | wc -l | tr -d ' ')

# ファイルが存在しない場合
if [ "$file_count" -eq 0 ]; then
  printf "削除対象のファイルがありません"
  exit 0
fi

# ファイルを削除
find "$screenshot_dir" -type f -delete

# 結果を表示
printf "削除完了: %d個のファイルを削除しました" "$file_count"
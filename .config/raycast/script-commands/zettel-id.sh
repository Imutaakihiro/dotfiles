#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Zettel ID
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🆔

# Documentation:
# @raycast.description Zettelkasten の Zettel ID を作成する。
# @raycast.author tanuuuuuuu
# @raycast.authorURL https://raycast.com/tanuuuuuuu

# クリップボードから内容を取得
clipboard_content=$(pbpaste)

# 日付フォーマットの正規表現パターン (YYYY-MM-DDThh:mm:ss+hh:mm)
date_pattern="^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}[+-][0-9]{2}:[0-9]{2}$"

# クリップボードの内容が正しいフォーマットかチェック
if [[ $clipboard_content =~ $date_pattern ]]; then
  # タイムゾーン部分を修正（:を削除してdate -jに適合させる）
  input_date=$(echo "$clipboard_content" | sed 's/\([+-][0-9][0-9]\):\([0-9][0-9]\)$/\1\2/')
else
  # フォーマットが合わない場合は現在時刻を使用
  input_date="$(date +"%Y-%m-%dT%H:%M:%S%z")"
fi

# Zettel ID を生成
zettel_id=$(date -j -f "%Y-%m-%dT%H:%M:%S%z" "$input_date" +"%Y%m%d%H%M")

# 結果をクリップボードにコピーして表示
pbcopy <<< "$zettel_id"
printf "Zettel ID: %s\n" "$zettel_id"
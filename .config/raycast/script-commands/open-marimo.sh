#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Marimo
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🟢
# @raycast.argument1 { "type": "text", "placeholder": "notebook name", "optional": true }

# Documentation:
# @raycast.description Desktopでスタンドアロンのmarimoノートブックを開く
# @raycast.author tanuuuuuuu
# @raycast.authorURL https://raycast.com/tanuuuuuuu

# PATHを設定（Raycast実行時に環境変数が読み込まれない場合に備える）
export PATH="$HOME/.local/bin:$PATH"

# 引数を受け取る（デフォルト値は my_notebook）
NOTEBOOK_NAME="${1:-my_notebook}"

# Desktopに移動
cd ~/Desktop || exit 1

# marimoを起動
uvx marimo edit --sandbox "${NOTEBOOK_NAME}.py"
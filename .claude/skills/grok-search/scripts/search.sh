#!/bin/bash
# macOS キーチェーンから Grok API キーを取得し、
# xAI Responses API の x_search ツールで X の投稿を検索するスクリプト。
# macOS 専用（security コマンドを使用）。
#
# 使い方: bash search.sh <クエリ> [オプション JSON]
# 例: bash search.sh "dbt の最新動向"
# 例: bash search.sh "Elon Musk の AI 発言" '{"handles":["elonmusk"],"from":"2026-01-01","to":"2026-02-14"}'

set -euo pipefail

QUERY="${1:?クエリを指定してください}"
OPTIONS="${2:-}"

# キーチェーンから API キー取得
XAI_API_KEY=$(security find-generic-password -s "Grok-API-Key" -w 2>/dev/null) || {
    echo '{"error": "キーチェーンから Grok API キーを取得できませんでした。次のコマンドで登録してください: security add-generic-password -s \"Grok-API-Key\" -a \"grok\" -w \"your-api-key\""}'
    exit 1
}

# x_search ツール設定を構築
X_SEARCH_TOOL='{"type": "x_search"}'
if [ -n "$OPTIONS" ]; then
    X_SEARCH_TOOL=$(echo "$OPTIONS" | jq '{type: "x_search"}
        + (if .handles then {allowed_x_handles: .handles} else {} end)
        + (if .from then {from_date: .from} else {} end)
        + (if .to then {to_date: .to} else {} end)')
fi

# API 呼び出し
RESPONSE=$(curl -s --max-time 30 "https://api.x.ai/v1/responses" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $XAI_API_KEY" \
    -d "$(jq -n \
        --arg query "$QUERY" \
        --argjson tool "$X_SEARCH_TOOL" \
        '{
            model: "grok-4-1-fast-reasoning",
            input: [{role: "user", content: $query}],
            tools: [$tool]
        }')")

# レスポンス検証
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
    echo "$RESPONSE"
    exit 1
fi

echo "$RESPONSE"

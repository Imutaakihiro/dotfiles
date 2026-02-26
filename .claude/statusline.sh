#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
DISPLAY_DIR=$(echo "$CURRENT_DIR" | sed "s|^$HOME|~|")

# 色の定義 (GitHub Dark テーマ)
BLUE=$'\033[38;2;88;166;255m'
GREEN=$'\033[38;2;63;185;80m'
YELLOW=$'\033[38;2;210;153;34m'
MAGENTA=$'\033[38;2;188;140;255m'
RED=$'\033[38;2;248;81;85m'
RESET=$'\033[0m'

# 相対時間をフォーマット (epoch → "23m", "1h30m" 等)
format_remaining() {
    local diff=$(( $1 - $2 ))
    if [ "$diff" -le 0 ]; then
        echo "0m"
    elif [ "$diff" -lt 3600 ]; then
        echo "$((diff / 60))m"
    else
        local h=$((diff / 3600))
        local m=$(((diff % 3600) / 60))
        if [ "$m" -eq 0 ]; then echo "${h}h"; else echo "${h}h${m}m"; fi
    fi
}

# コンテキストウィンドウ使用率を計算
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size')
USAGE=$(echo "$input" | jq '.context_window.current_usage')

# コンテキストウィンドウ + quota 情報を組み立て
CONTEXT_QUOTA=""
if [ "$USAGE" != "null" ] && [ "$CONTEXT_SIZE" != "null" ] && [ "$CONTEXT_SIZE" != "0" ]; then
    CURRENT_TOKENS=$(echo "$USAGE" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
    PERCENT=$((CURRENT_TOKENS * 100 / CONTEXT_SIZE))
    CTX_PART="${MAGENTA}ctx:${PERCENT}%${RESET}"

    # Quota キャッシュ読み取り・バックグラウンド更新
    QUOTA_CACHE="/tmp/claude-quota-cache"
    QUOTA_CACHE_TTL=60
    QUOTA_PART=""

    # キャッシュの経過秒数を取得
    if [ -f "$QUOTA_CACHE" ]; then
        CACHE_AGE=$(( $(date +%s) - $(stat -f %m "$QUOTA_CACHE") ))
    else
        CACHE_AGE=$(( QUOTA_CACHE_TTL + 1 ))
    fi

    # キャッシュが古い場合はバックグラウンドで更新
    if [ "$CACHE_AGE" -gt "$QUOTA_CACHE_TTL" ]; then
        (
            QUOTA_JSON=$(bash ~/.claude/scripts/fetch_usage.sh 2>/dev/null)
            if echo "$QUOTA_JSON" | jq -e '.five_hour' > /dev/null 2>&1; then
                FIVE_H=$(echo "$QUOTA_JSON" | jq -r '.five_hour.utilization')
                SEVEN_D=$(echo "$QUOTA_JSON" | jq -r '.seven_day.utilization')
                # リセット時刻を epoch に変換 (macOS date)
                FIVE_H_RESET=$(echo "$QUOTA_JSON" | jq -r '.five_hour.resets_at' | sed 's/\.[0-9]*//' | sed 's/\([-+][0-9][0-9]\):\([0-9][0-9]\)$/\1\2/')
                FIVE_H_EPOCH=$(date -j -f "%Y-%m-%dT%H:%M:%S%z" "$FIVE_H_RESET" "+%s" 2>/dev/null || echo "0")
                SEVEN_D_RESET=$(echo "$QUOTA_JSON" | jq -r '.seven_day.resets_at' | sed 's/\.[0-9]*//' | sed 's/\([-+][0-9][0-9]\):\([0-9][0-9]\)$/\1\2/')
                SEVEN_D_EPOCH=$(date -j -f "%Y-%m-%dT%H:%M:%S%z" "$SEVEN_D_RESET" "+%s" 2>/dev/null || echo "0")
                echo "$FIVE_H $SEVEN_D $FIVE_H_EPOCH $SEVEN_D_EPOCH" > "$QUOTA_CACHE"
            fi
        ) &
    fi

    # キャッシュから quota 値を読み取り
    if [ -f "$QUOTA_CACHE" ]; then
        read -r FIVE_H SEVEN_D FIVE_H_EPOCH SEVEN_D_EPOCH < "$QUOTA_CACHE"
        if [ -n "$FIVE_H" ] && [ -n "$SEVEN_D" ]; then
            FIVE_H_INT=$(printf "%.0f" "$FIVE_H")
            SEVEN_D_INT=$(printf "%.0f" "$SEVEN_D")
            NOW=$(date +%s)

            # 5h の色分け + 条件付きリセット時間
            FIVE_H_COLOR="$RESET"
            FIVE_H_RESET_STR=""
            if [ "$FIVE_H_INT" -ge 90 ]; then
                FIVE_H_COLOR="$RED"
            elif [ "$FIVE_H_INT" -ge 70 ]; then
                FIVE_H_COLOR="$YELLOW"
            fi
            if [ "$FIVE_H_INT" -ge 70 ] && [ -n "$FIVE_H_EPOCH" ] && [ "$FIVE_H_EPOCH" != "0" ]; then
                FIVE_H_RESET_STR=" ↻$(format_remaining "$FIVE_H_EPOCH" "$NOW")"
            fi

            # 7d の色分け + 条件付きリセット時間
            SEVEN_D_COLOR="$RESET"
            SEVEN_D_RESET_STR=""
            if [ "$SEVEN_D_INT" -ge 90 ]; then
                SEVEN_D_COLOR="$RED"
            elif [ "$SEVEN_D_INT" -ge 70 ]; then
                SEVEN_D_COLOR="$YELLOW"
            fi
            if [ "$SEVEN_D_INT" -ge 70 ] && [ -n "$SEVEN_D_EPOCH" ] && [ "$SEVEN_D_EPOCH" != "0" ]; then
                SEVEN_D_RESET_STR=" ↻$(format_remaining "$SEVEN_D_EPOCH" "$NOW")"
            fi

            QUOTA_PART=" (${FIVE_H_COLOR}5h:${FIVE_H_INT}%${FIVE_H_RESET_STR}${RESET}, ${SEVEN_D_COLOR}7d:${SEVEN_D_INT}%${SEVEN_D_RESET_STR}${RESET})"
        fi
    fi

    CONTEXT_QUOTA=" | ${CTX_PART}${QUOTA_PART}"
fi

# Gitブランチとdirty状態を取得
GIT_INFO=""
if git -C "$CURRENT_DIR" rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git -C "$CURRENT_DIR" branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        DIRTY=""
        if [ -n "$(git -C "$CURRENT_DIR" status --porcelain 2>/dev/null)" ]; then
            DIRTY="${YELLOW}*${RESET}"
        fi
        GIT_INFO=" | ${GREEN}${BRANCH}${RESET}${DIRTY}"
    fi
fi

echo -e "[$MODEL] ${BLUE}${DISPLAY_DIR}${RESET}${GIT_INFO}${CONTEXT_QUOTA}"

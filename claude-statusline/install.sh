#!/bin/bash

# Claude Code Statusline 一鍵安裝腳本
# 用法: ./install.sh

set -e

echo "=== Claude Code Statusline 安裝程式 ==="
echo ""

# 取得腳本所在目錄
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 檢查 Go
if ! command -v go &> /dev/null; then
    echo "❌ 錯誤：需要安裝 Go"
    echo "   macOS: brew install go"
    echo "   Ubuntu: sudo apt install golang"
    exit 1
fi
echo "✅ Go 已安裝: $(go version | cut -d' ' -f3)"

# 檢查 jq
if ! command -v jq &> /dev/null; then
    echo "⚠️  警告：jq 未安裝（統計腳本需要）"
    echo "   macOS: brew install jq"
    echo "   Ubuntu: sudo apt install jq"
fi

# 創建目錄
echo ""
echo "📁 創建目錄..."
mkdir -p ~/.claude/session-tracker/sessions
mkdir -p ~/.claude/cache

# 複製檔案
echo "📄 複製檔案..."
cp "$SCRIPT_DIR/statusline.go" ~/.claude/
cp "$SCRIPT_DIR/claude-stats.sh" ~/.claude/
chmod +x ~/.claude/claude-stats.sh

# 編譯 Go 程式
echo "🔨 編譯 statusline..."
cd ~/.claude
go build -o statusline-go statusline.go
chmod +x statusline-go

# 更新 settings.json
echo "⚙️  設定 settings.json..."
SETTINGS_FILE=~/.claude/settings.json
STATUSLINE_CONFIG='"statusLine": {"type": "command", "command": "~/.claude/statusline-go", "padding": 0}'

if [ -f "$SETTINGS_FILE" ]; then
    # 備份
    cp "$SETTINGS_FILE" "$SETTINGS_FILE.bak"

    # 檢查是否已有 statusLine 設定
    if grep -q '"statusLine"' "$SETTINGS_FILE"; then
        echo "   statusLine 設定已存在，跳過"
    else
        # 使用 jq 新增設定
        if command -v jq &> /dev/null; then
            jq '. + {"statusLine": {"type": "command", "command": "~/.claude/statusline-go", "padding": 0}}' \
                "$SETTINGS_FILE.bak" > "$SETTINGS_FILE"
        else
            echo "   ⚠️  請手動新增 statusLine 設定到 settings.json"
        fi
    fi
else
    # 創建新檔案
    echo "{$STATUSLINE_CONFIG}" > "$SETTINGS_FILE"
fi

# 測試
echo ""
echo "🧪 測試 statusline..."
TEST_OUTPUT=$(echo '{"model":{"display_name":"Claude Sonnet 4"},"session_id":"test","workspace":{"current_dir":"/tmp"},"transcript_path":""}' | ~/.claude/statusline-go 2>&1)
if [ $? -eq 0 ]; then
    echo "   $TEST_OUTPUT"
    echo "✅ 測試通過"
else
    echo "❌ 測試失敗"
    exit 1
fi

# 完成
echo ""
echo "=========================================="
echo "✅ 安裝完成！"
echo ""
echo "請重啟 Claude Code 以啟用新的 statusline"
echo ""
echo "可選：新增統計指令到 shell"
echo ""
echo "將以下內容加入 ~/.zshrc 或 ~/.bashrc："
echo ""
echo '# Claude Code stats function'
echo '#   claude-stats          # 今日統計'
echo '#   claude-stats week     # 本週'
echo '#   claude-stats month    # 本月'
echo '#   claude-stats all      # 全部歷史'
echo 'claude-stats() {'
echo '  ~/.claude/claude-stats.sh "$@"'
echo '}'
echo ""
echo "=========================================="

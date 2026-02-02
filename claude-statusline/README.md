# Claude Code Statusline 設定指南

自訂 Claude Code statusline，顯示模型、專案、Git 分支、Context 使用量和使用時數。

Refer: https://jackle.pro/articles/claude-code-status-line

## 預覽效果

```
[💛 Claude Opus 4.5] 📂 my-project ⚡ main | ██████░░░░ 58% 116k | 2h35m
｜這是最後一條使用者訊息...
```

## 功能特色

- **模型顯示**：Opus 💛金色 / Sonnet 💠藍色 / Haiku 🌸粉色
- **專案名稱**：當前工作目錄
- **Git 分支**：⚡ 分支名（5秒快取優化）
- **Context 使用量**：彩色進度條 + 百分比 + token 數
  - 綠色 (<60%) → 金色 (60-80%) → 紅色 (>80%)
- **今日使用時數**：自動追蹤，支援多 session
- **最後訊息**：顯示最近的使用者輸入（最多3行）

## 快速安裝

### 前置需求

- Go 1.19+
- jq（統計腳本需要）

```bash
# macOS
brew install go jq

# Ubuntu/Debian
sudo apt install golang jq
```

### 步驟 1：下載檔案

將以下檔案放到 `~/.claude/` 目錄：

```bash
mkdir -p ~/.claude
```

複製這些檔案：
- `statusline.go` - Go 源碼
- `claude-stats.sh` - 統計腳本

### 步驟 2：編譯 Go 程式

```bash
cd ~/.claude
go build -o statusline-go statusline.go
chmod +x statusline-go
chmod +x claude-stats.sh
```

### 步驟 3：創建必要目錄

```bash
mkdir -p ~/.claude/session-tracker/sessions
mkdir -p ~/.claude/cache
```

### 步驟 4：設定 settings.json

編輯 `~/.claude/settings.json`，新增 statusLine 設定：

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline-go",
    "padding": 0
  }
}
```

如果檔案已存在其他設定，在最外層 `{}` 內新增 `statusLine` 區塊即可。

### 步驟 5：新增 Shell Function（可選）

在 `~/.zshrc` 或 `~/.bashrc` 新增：

```bash
# Claude Code stats function
#   claude-stats          # 今日統計
#   claude-stats week     # 本週
#   claude-stats month    # 本月
#   claude-stats all      # 全部歷史
claude-stats() {
  ~/.claude/claude-stats.sh "$@"
}
```

重新載入設定：

```bash
source ~/.zshrc  # 或 source ~/.bashrc
```

### 步驟 6：重啟 Claude Code

關閉並重新啟動 Claude Code 即可看到新的 statusline。

## 一鍵安裝腳本

```bash
#!/bin/bash

# 創建目錄
mkdir -p ~/.claude/session-tracker/sessions
mkdir -p ~/.claude/cache

# 下載檔案（請替換為實際的檔案來源）
# curl -o ~/.claude/statusline.go <URL>
# curl -o ~/.claude/claude-stats.sh <URL>

# 編譯
cd ~/.claude
go build -o statusline-go statusline.go
chmod +x statusline-go
chmod +x claude-stats.sh

# 備份並更新 settings.json
if [ -f ~/.claude/settings.json ]; then
  cp ~/.claude/settings.json ~/.claude/settings.json.bak
  # 使用 jq 新增 statusLine 設定
  jq '. + {"statusLine": {"type": "command", "command": "~/.claude/statusline-go", "padding": 0}}' \
    ~/.claude/settings.json.bak > ~/.claude/settings.json
else
  echo '{"statusLine": {"type": "command", "command": "~/.claude/statusline-go", "padding": 0}}' \
    > ~/.claude/settings.json
fi

echo "安裝完成！請重啟 Claude Code。"
```

## 使用統計指令

```bash
claude-stats              # 今日統計
claude-stats week         # 本週統計
claude-stats month        # 本月統計
claude-stats all          # 所有歷史
claude-stats 2025-01-15   # 指定日期
claude-stats archive      # 歸檔舊 session
```

輸出範例：

```
=== 本週統計 ===
統計範圍: 2025-01-27 至 2025-02-02
----------------------------------------
  2025-01-27 (一):  3h 45m (5 sessions)
  2025-01-28 (二):  2h 30m (3 sessions)
  2025-01-29 (三):  4h 15m (6 sessions)
----------------------------------------
總計: 10h 30m (14 sessions)
```

## 檔案結構

```
~/.claude/
├── statusline.go          # Go 源碼
├── statusline-go          # 編譯後執行檔
├── claude-stats.sh        # 統計腳本
├── settings.json          # Claude Code 設定
├── cache/
│   └── git_branch         # Git 分支快取
└── session-tracker/
    ├── sessions/          # 當前 session 資料
    │   └── <session-id>.json
    └── archive/           # 歸檔的歷史資料
        └── 2025-01-27/
            └── <session-id>.json
```

## 常見問題

### Q: Statusline 沒有顯示？

1. 確認 `statusline-go` 有執行權限：`chmod +x ~/.claude/statusline-go`
2. 確認 `settings.json` 格式正確（JSON 語法）
3. 重啟 Claude Code

### Q: Context 使用量顯示 0%？

對話剛開始時為 0%，發送訊息後會更新。

### Q: 統計腳本報錯？

確認已安裝 jq：`brew install jq` 或 `apt install jq`

### Q: 切換模型時 statusline 有延遲？

這是正常現象，Go 版本已大幅優化，延遲約 50-100ms。

## 自訂修改

如需修改顯示內容，編輯 `statusline.go` 後重新編譯：

```bash
cd ~/.claude
go build -o statusline-go statusline.go
```

### 修改模型顏色/圖示

編輯 `modelConfig` 變數：

```go
var modelConfig = map[string][2]string{
    "Opus":   {ColorGold, "💛"},
    "Sonnet": {ColorCyan, "💠"},
    "Haiku":  {ColorPink, "🌸"},
}
```

### 修改 Context 上限

預設為 200k tokens，編輯 `analyzeContext` 函數中的數值。

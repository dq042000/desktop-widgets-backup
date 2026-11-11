#!/usr/bin/env bash
# 重新匯出目前的桌面小工具設定（conky）
# 用法：在本資料夾內執行 ./export.sh
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> 匯出 conky 設定"
mkdir -p "$DIR/conky"
cp -f "$HOME"/.config/conky/*.conf "$DIR/conky/"

echo "==> 匯出 conky 開機自動啟動設定"
if [ -f "$HOME/.config/autostart/conky.desktop" ]; then
  cp -f "$HOME/.config/autostart/conky.desktop" "$DIR/conky.desktop"
  echo "    已備份 conky.desktop"
else
  echo "    略過：找不到 conky.desktop"
fi

echo ""
echo "完成：設定已更新到本資料夾，請 git commit 後 push"

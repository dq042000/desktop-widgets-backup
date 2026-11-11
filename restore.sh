#!/usr/bin/env bash
# 桌面小工具設定還原腳本（conky：時鐘 + 系統監控）
# 用法：在本資料夾內執行 ./restore.sh
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> 1/4 安裝 conky 與中文字型"
PKGS=()
command -v conky >/dev/null 2>&1 || PKGS+=(conky-all)
fc-list 'Noto Sans CJK TC' 2>/dev/null | grep -q . || PKGS+=(fonts-noto-cjk)
if [ ${#PKGS[@]} -eq 0 ]; then
  echo "    已安裝，略過"
elif command -v apt-get >/dev/null 2>&1; then
  sudo apt-get install -y "${PKGS[@]}"
else
  echo "    錯誤：非 apt 系統，請手動安裝 ${PKGS[*]}"
  exit 1
fi

echo "==> 2/4 還原 conky 設定"
mkdir -p "$HOME/.config/conky"
cp -f "$DIR"/conky/*.conf "$HOME/.config/conky/"
echo "    完成"

echo "==> 3/4 還原開機自動啟動"
mkdir -p "$HOME/.config/autostart"
cp -f "$DIR/conky.desktop" "$HOME/.config/autostart/conky.desktop"
echo "    完成"

echo "==> 4/4 重啟 conky"
pkill -x conky || true
# 等舊的 conky 完全結束，避免新舊視窗衝突導致新的一啟動就結束
while pgrep -x conky >/dev/null; do sleep 0.2; done
conky -d -c "$HOME/.config/conky/conky.conf" >/dev/null 2>&1
conky -d -c "$HOME/.config/conky/sysmon.conf" >/dev/null 2>&1
echo "    conky 已重啟"

echo ""
echo "全部完成。若監控資訊與時鐘重疊，請調整 ~/.config/conky/sysmon.conf 的 gap_y 後重新執行 ./export.sh"

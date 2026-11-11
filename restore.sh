#!/usr/bin/env bash
# 桌面小工具設定還原腳本（conky：時鐘 + 系統監控）
# 用法：在本資料夾內執行 ./restore.sh
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> 1/4 安裝 conky、中文字型與 node"
PKGS=()
if command -v conky >/dev/null 2>&1; then
  echo "    conky：已安裝，略過"
else
  echo "    conky：未安裝，將安裝 conky-all"
  PKGS+=(conky-all)
fi
if fc-list 'Noto Sans CJK TC' 2>/dev/null | grep -q .; then
  echo "    Noto Sans CJK TC 字型：已安裝，略過"
else
  echo "    Noto Sans CJK TC 字型：未安裝，將安裝 fonts-noto-cjk"
  PKGS+=(fonts-noto-cjk)
fi
# 農曆由 conky/lunar.sh 透過 node 計算；nvm 安裝的 node 不在 PATH，需另外找
if command -v node >/dev/null 2>&1 || ls "$HOME"/.nvm/versions/node/*/bin/node >/dev/null 2>&1; then
  echo "    node：已安裝，略過"
else
  echo "    node：未安裝，將安裝 nodejs"
  PKGS+=(nodejs)
fi
if [ ${#PKGS[@]} -eq 0 ]; then
  :
elif command -v apt-get >/dev/null 2>&1; then
  sudo apt-get install -y "${PKGS[@]}"
else
  echo "    錯誤：非 apt 系統，請手動安裝 ${PKGS[*]}"
  exit 1
fi

echo "==> 2/4 還原 conky 設定"
mkdir -p "$HOME/.config/conky"
cp -f "$DIR"/conky/*.conf "$HOME/.config/conky/"
cp -f "$DIR"/conky/*.sh "$HOME/.config/conky/" 2>/dev/null || true
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

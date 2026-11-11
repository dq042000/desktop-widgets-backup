# desktop-widgets-backup

Ubuntu 桌面小工具設定備份，可在新機器上一鍵還原。目前內容為 conky 的右上角時鐘與系統監控。

## 內容

| 檔案 / 資料夾 | 說明 |
| --- | --- |
| `restore.sh` | 一鍵還原腳本（安裝 conky 與字型 + 還原設定 + 開機自動啟動 + 重啟 conky） |
| `export.sh` | 一鍵匯出腳本（重新匯出目前設定到本資料夾） |
| `conky/conky.conf` | 時鐘：時間與日期，置於右上角 |
| `conky/sysmon.conf` | 系統監控：CPU、記憶體、顯示卡、硬碟，置於時鐘下方 |
| `conky.desktop` | 開機自動啟動設定（`~/.config/autostart/`） |

## 設定重點

- 字型：`Noto Sans CJK TC`（時鐘 56 號、監控 11 號）
- 位置：右上角，監控區塊在時鐘下方（`sysmon.conf` 的 `gap_y = 215`）
- 監控項目：
  - CPU 使用率
  - 記憶體用量
  - 顯示卡使用率、溫度、顯示記憶體（透過 `nvidia-smi`，每 2 秒更新）
  - 硬碟 `/` 與 `/home` 用量、讀寫速度

## 還原方式

在本資料夾內執行：

```bash
git pull
./restore.sh
```

腳本會依序執行：

1. 若缺少則以 apt 安裝 `conky-all` 與 `fonts-noto-cjk`
2. 將 `conky/*.conf` 複製到 `~/.config/conky/`
3. 將 `conky.desktop` 複製到 `~/.config/autostart/`，開機自動啟動
4. 重啟 conky

注意事項：

- 顯示卡資訊需要 NVIDIA 顯示卡與 `nvidia-smi`，沒有的話該區塊會是空的
- `/home` 不是獨立分割區時，`/home` 那行會與 `/` 顯示相同數字
- 螢幕解析度不同時，監控區塊可能與時鐘重疊，調整 `sysmon.conf` 的 `gap_y` 即可

## 備份方式

更新備份時，在本資料夾內執行：

```bash
./export.sh
git commit -am "chore: 更新桌面小工具設定備份"
git push
```

`export.sh` 會把 `~/.config/conky/*.conf` 與 `~/.config/autostart/conky.desktop` 複製到本資料夾，接著以 git 提交推送即完成備份。

> 第一次新增檔案（例如新的 `.conf`）時，`git commit -am` 不會包含新檔，請先 `git add .`。

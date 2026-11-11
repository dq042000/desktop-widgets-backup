#!/bin/sh
# 印出今天的農曆日期（例：農曆 丙午年十月初三），使用 Node.js 內建的 Intl 中國曆法
# conky 執行時沒有 nvm 的 PATH，所以找不到 node 時改從 ~/.nvm 取最新版本
NODE=$(command -v node || ls -d "$HOME"/.nvm/versions/node/*/bin/node 2>/dev/null | sort -V | tail -1)
[ -n "$NODE" ] || exit 0
"$NODE" -e 'console.log("農曆 " + new Date().toLocaleDateString("zh-TW-u-ca-chinese", { dateStyle: "long" }).replace(/^\d+/, ""))'

#!/usr/bin/env bash

__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)

cd ${__DIR__}

test -f /etc/apk/repositories.d/distfeeds.list.bak || cp /etc/apk/repositories.d/distfeeds.list /etc/apk/repositories.d/distfeeds.list.bak
sed -i.bak 's_https\?://downloads.openwrt.org_https://mirrors.tuna.tsinghua.edu.cn/openwrt_' /etc/apk/repositories.d/distfeeds.list

# 更新索引
apk update
# 安装中文语言包
apk install luci-i18n-base-zh-cn

# 包安装命令
apk install luci-theme-material
apk install curl bash git xz unzip

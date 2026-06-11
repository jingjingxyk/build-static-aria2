#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}
shopt -s expand_aliases
cd ${__PROJECT__}

mkdir -p ${__PROJECT__}/var/
cd ${__PROJECT__}/var/

APP_VERSION='25.12.4'
APP_NAME='openwrt'
VERSION='25.12.4'
mkdir -p ${APP_NAME}
cd ${APP_NAME}

# openwrt 软件源
# 教育网联合镜像站
# https://mirrors.cernet.edu.cn/openwrt
# https://mirrors.cernet.edu.cn/list/openwrt
# homepage
# https://openwrt.org/docs/guide-user/installation/openwrt_x86
# https://archive.openwrt.org/releases/
# https://archive.openwrt.org/releases/25.12.3/targets/x86/generic/

# curl -LSo openwrt-25.12.3-x86-generic-generic-ext4-combined.img.gz https://archive.openwrt.org/releases/25.12.3/targets/x86/generic/openwrt-25.12.3-x86-generic-generic-ext4-combined.img.gz

if [ -f runtime/aria2c/aria2c ]; then
  curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-aria2-runtime.sh?raw=ture | bash -s -- --mirror china
fi
export PATH="${__PROJECT__}/runtime/aria2c/:$PATH"
which aria2c

aria2c --file-allocation=none -c -x4 -s16 \
  https://mirrors.tuna.tsinghua.edu.cn/openwrt/releases/${VERSION}/targets/x86/64/openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.img.gz \
  https://mirrors.cqupt.edu.cn/openwrt/releases/${VERSION}/targets/x86/64/openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.img.gz \
  https://mirrors.hit.edu.cn/openwrt/releases/${VERSION}/targets/x86/64/openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.img.gz

# https://archive.openwrt.org/releases/25.12.3/targets/x86/64/openwrt-25.12.3-x86-64-generic-ext4-combined.img.gz

test -f openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.img && rm -f openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.img
# gzip -d openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.img.gz
# 保持解压前原文件
gzip -c openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.img.gz >openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.img

# 将文件填充到对其
truncate -s 13M openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.img

# img 文件转换为 vdi
test -f openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.vdi && rm -f openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.vdi
VBoxManage convertfromraw --format VDI openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.img openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.vdi

# 修改磁盘大小
VBoxManage modifyhd --resize 8096 openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.vdi
VBoxManage showhdinfo openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.vdi

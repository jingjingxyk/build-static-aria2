#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}
shopt -s expand_aliases
cd ${__PROJECT__}


while [ $# -gt 0 ]; do
  case "$1" in
  --proxy)
    export HTTP_PROXY="$2"
    export HTTPS_PROXY="$2"
    NO_PROXY="127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16"
    NO_PROXY="${NO_PROXY},::1/128,fe80::/10,fd00::/8,ff00::/8"
    NO_PROXY="${NO_PROXY},localhost"
    NO_PROXY="${NO_PROXY},.aliyuncs.com,.aliyun.com,.tencent.com"
    NO_PROXY="${NO_PROXY},.myqcloud.com,.swoole.com"
    export NO_PROXY="${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn,.npmmirror.com"
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done


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

# 参考文档
# https://openwrt.org/docs/guide-user/virtualization/virtualbox-vm

# curl -LSo openwrt-25.12.3-x86-64-generic-ext4-combined.img.gz https://archive.openwrt.org/releases/25.12.3/targets/x86/64/openwrt-25.12.3-x86-64-generic-ext4-combined.img.gz

if [ -f runtime/aria2c/aria2c ]; then
  curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-aria2-runtime.sh?raw=ture | bash -s -- --mirror china
fi
export PATH="${__PROJECT__}/runtime/aria2c/:$PATH"
which aria2c

aria2c --file-allocation=none -c -x4 -s16 \
  https://mirrors.tuna.tsinghua.edu.cn/openwrt/releases/${VERSION}/targets/x86/64/openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.img.gz \
  https://mirrors.cqupt.edu.cn/openwrt/releases/${VERSION}/targets/x86/64/openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.img.gz \
  https://mirrors.hit.edu.cn/openwrt/releases/${VERSION}/targets/x86/64/openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.img.gz


test -f openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.img && rm -f openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.img
gzip -d openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.img.gz

# 将文件填充到对其
test -f openwrt.img && rm -f openwrt.img
dd if=openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.img of=openwrt.img bs=128000 conv=sync
# truncate -s %512 openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.img

# img 文件转换为 vdi
test -f openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.vdi && rm -f openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.vdi
VBoxManage convertfromraw --format VDI openwrt.img openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.vdi

# 显示vdi 信息
VBoxManage showhdinfo openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.vdi

# 修改磁盘大小 8GB
VBoxManage modifymedium disk openwrt-${APP_VERSION}-x86-64-generic-ext4-combined.vdi --resize 8096

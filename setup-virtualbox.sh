#!/usr/bin/env bash

set -xu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}
shopt -s expand_aliases
cd ${__PROJECT__}

OS=$(uname -s)
ARCH=$(uname -m)

case $OS in
'Linux')
  OS="linux"
  ;;
'Darwin')
  OS="macos"
  ;;
*)
  case $OS in
  'MSYS_NT'*)
    OS="windows"
    ;;
  'MINGW64_NT'*)
    OS="windows"
    ;;
  *)
    echo '暂未配置的 OS '
    exit 0
    ;;
  esac
  ;;
esac

case $ARCH in
'x86_64')
  ARCH="x64"
  ;;
'aarch64' | 'arm64')
  ARCH="arm64"
  ;;
*)
  echo '暂未配置的 ARCH '
  exit 0
  ;;
esac

APP_VERSION='7.2.10'
APP_NAME='VirtualBox'
VERSION='7.2.10'

cd ${__PROJECT__}
mkdir -p runtime
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

# https://download.virtualbox.org/virtualbox/
# https://mirrors.cernet.edu.cn/list/virtualbox

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

cd ${__PROJECT__}/var/runtime

::EOF

https://download.virtualbox.org/virtualbox/7.2.8/VirtualBox-7.2.8-173730-OSX.dmg
https://mirrors.tuna.tsinghua.edu.cn/virtualbox/7.2.10/VirtualBox-7.2.10-174163-Win.exe
https://mirrors.tuna.tsinghua.edu.cn/virtualbox/7.2.10/VirtualBox-7.2.10-174163-OSX.dmg
https://mirrors.tuna.tsinghua.edu.cn/virtualbox/7.2.10/VBoxGuestAdditions_7.2.10.iso

EOF

downloader() {
  local file=$1
  local url=$2
  local cmd=$(echo "curl -fSLo $file $url ")
  eval $cmd
}

downloader VirtualBox-7.2.10-174163-OSX.dmg https://mirrors.tuna.tsinghua.edu.cn/virtualbox/7.2.10/VirtualBox-7.2.10-174163-OSX.dmg
cd ${__PROJECT__}/var/runtime

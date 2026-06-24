#!/usr/bin/env bash

set -xu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}
shopt -s expand_aliases
cd ${__PROJECT__}

: <<<EOF
https://github.com/EasyTier/EasyTier/releases/tag/v2.6.4

EOF

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
  ARCH="x86_64"
  ;;
'aarch64' | 'arm64')
  ARCH="arm64"
  ;;
*)
  echo '暂未配置的 ARCH '
  exit 0
  ;;
esac

APP_VERSION='v2.6.4'
APP_NAME='easytier'
VERSION='v2.6.4'

cd ${__PROJECT__}
mkdir -p runtime
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

MIRROR=''
CURL_OPTIONS=""
while [ $# -gt 0 ]; do
  case "$1" in
  --mirror)
    MIRROR="$2"
    ;;
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

APP_DOWNLOAD_URL="https://github.com/EasyTier/EasyTier/releases/download/${VERSION}/${APP_NAME}-${OS}-${ARCH}-${APP_VERSION}.zip"
CACERT_DOWNLOAD_URL="https://curl.se/ca/cacert.pem"

case "$MIRROR" in
china)
  APP_DOWNLOAD_URL="https://storage.jingjingxyk.com/${APP_NAME}/${APP_VERSION}/${APP_NAME}-${OS}-${ARCH}-${APP_VERSION}.zip"
  ;;

esac

downloader() {
  local file=$1
  local url=$2
  CURL_OPTIONS="-H 'Referer: https://github.com/EasyTier/EasyTier/releases' -H 'User-Agent: \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36\"' "
  local cmd=$(echo "curl $CURL_OPTIONS -fSLo $file $url ")
  eval $cmd
}

test -f ${APP_NAME}-${OS}-${ARCH}-${APP_VERSION}.zip || downloader ${APP_NAME}-${OS}-${ARCH}-${APP_VERSION}.zip ${APP_DOWNLOAD_URL}

7z x ${APP_NAME}-${OS}-${ARCH}-${APP_VERSION}.zip -aoa -y -o${APP_NAME}-${OS}-${ARCH}-${APP_VERSION}

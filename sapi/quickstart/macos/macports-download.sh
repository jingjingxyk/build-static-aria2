#!/usr/bin/env bash

set -x
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../../
  pwd
)
cd ${__PROJECT__}
mkdir -p ${__PROJECT__}/var/
cd ${__PROJECT__}/var/

while [ $# -gt 0 ]; do
  case "$1" in
  --proxy)
    export HTTP_PROXY="$2"
    export HTTPS_PROXY="$2"
    NO_PROXY="127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16"
    NO_PROXY="${NO_PROXY},::1/128,fe80::/10,fd00::/8,ff00::/8"
    NO_PROXY="${NO_PROXY},localhost"
    NO_PROXY="${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn"
    NO_PROXY="${NO_PROXY},.tencent.com"
    NO_PROXY="${NO_PROXY},ftpmirror.gnu.org"
    NO_PROXY="${NO_PROXY},gitee.com,gitcode.com"
    NO_PROXY="${NO_PROXY},.myqcloud.com,.swoole.com"
    export NO_PROXY="${NO_PROXY},.npmmirror.com"
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

MACOS_VERSION=$(sw_vers | sed -n '2p' | cut -d ':' -f2 | cut -d '.' -f1 | sed -E 's/^[[:space:]]+|[[:space:]]+$//g')
echo $MACOS_VERSION

MACPORTS_DOWNLOAD_URL=''
MACPORTS_PACKAGE_NAME=''
case "$MACOS_VERSION" in
14)
  MACPORTS_DOWNLOAD_URL='https://github.com/macports/macports-base/releases/download/v2.12.5/MacPorts-2.12.5-14-Sonoma.pkg'
  MACPORTS_PACKAGE_NAME='MacPorts-2.12.5-14-Sonoma.pkg'
  ;;

15)
  MACPORTS_DOWNLOAD_URL='https://github.com/macports/macports-base/releases/download/v2.12.5/MacPorts-2.12.5-15-Sequoia.pkg'
  MACPORTS_PACKAGE_NAME='MacPorts-2.12.5-15-Sequoia.pkg'
  ;;
13)
  MACPORTS_DOWNLOAD_URL='https://github.com/macports/macports-base/releases/download/v2.12.5/MacPorts-2.12.5-13-Ventura.pkg'
  MACPORTS_PACKAGE_NAME='MacPorts-2.12.5-13-Ventura.pkg'
  ;;
12)
  MACPORTS_DOWNLOAD_URL='https://github.com/macports/macports-base/releases/download/v2.12.5/MacPorts-2.12.5-12-Monterey.pkg'
  MACPORTS_PACKAGE_NAME='MacPorts-2.12.5-12-Monterey.pkg'
  ;;
esac

curl -fSLo $MACPORTS_PACKAGE_NAME $MACPORTS_DOWNLOAD_URL

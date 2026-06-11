#!/bin/env bash

set -eux
__CURRENT__=$(pwd)
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

while [ $# -gt 0 ]; do
  case "$1" in
  --proxy)
    export HTTP_PROXY="$2"
    export HTTPS_PROXY="$2"
    NO_PROXY="127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16"
    NO_PROXY="${NO_PROXY},::1/128,fe80::/10,fd00::/8,ff00::/8"
    NO_PROXY="${NO_PROXY},.aliyuncs.com,.aliyun.com,.tencent.com"
    NO_PROXY="${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn,.npmmirror.com"
    NO_PROXY="${NO_PROXY},ftpmirror.gnu.org"
    NO_PROXY="${NO_PROXY},gitee.com,gitcode.com"
    NO_PROXY="${NO_PROXY},.myqcloud.com,.swoole.com"
    NO_PROXY="${NO_PROXY},dl-cdn.alpinelinux.org"
    NO_PROXY="${NO_PROXY},deb.debian.org,security.debian.org"
    NO_PROXY="${NO_PROXY},archive.ubuntu.com,security.ubuntu.com"
    NO_PROXY="${NO_PROXY},pypi.python.org,bootstrap.pypa.io"
    NO_PROXY="${NO_PROXY},cdn.unrealengine.com"
    NO_PROXY="${NO_PROXY},ssl.google-analytics.com"
    export NO_PROXY="${NO_PROXY},localhost"
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

export PATH=${__DIR__}/chromium/depot_tools:$PATH

export DEPOT_TOOLS_UPDATE=0
gclient metrics --opt-out

export NO_AUTH_BOTO_CONFIG=/root/.boto
cat /root/.boto
env

# export GIT_TRACE_PACKET=1
# export GIT_TRACE=1
# export GIT_CURL_VERBOSE=1

curl -I https://www.google.com

cd ${__DIR__}
which fetch

mkdir -p ${__DIR__}/chromium/webrtc

cd ${__DIR__}/chromium/webrtc
pwd

if [ -d ${__DIR__}/chromium/webrtc/src/ ]; then
  cd ${__DIR__}/chromium/webrtc/src/
  # git rebase-update
  # gclient sync
  # gclient sync -D --verbose  --nohooks --no-history --auto_rebase -R --shallow   -j$(nproc)

  git config branch.autosetupmerge always
  git config branch.autosetuprebase always
  git config pull.rebase false
  git pull origin main
else
  git clone -b main https://webrtc.googlesource.com/src
fi

cd ${__DIR__}/

exit 0

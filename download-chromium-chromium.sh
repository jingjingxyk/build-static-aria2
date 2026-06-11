#!/usr/bin/env bash

set -eux

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
# gclient metrics --opt-out

export NO_AUTH_BOTO_CONFIG=/root/.boto
cat /root/.boto
env

# export GIT_TRACE_PACKET=1
# export GIT_TRACE=1
# export GIT_CURL_VERBOSE=1

curl -I https://www.google.com

cd ${__DIR__}
which fetch

mkdir -p ${__DIR__}/chromium/chromium

cd ${__DIR__}/chromium/chromium
pwd

#  show tag
# https://chromium.googlesource.com/chromium/src/+refs

# git log --pretty=format:"%h %s" --graph

# shellcheck disable=SC2107
if [ -f '.gclient' ] && [ -d ${__DIR__}/chromium/chromium/src/ ]; then
  {
    #     gclient sync --nohooks --no-history --force --verbose # --verbose --verbose
    sed -i 's/"custom_vars": {}/"custom_vars": { \n        "checkout_pgo_profiles": True, \n    }/' ${__DIR__}/chromium/chromium/.gclient
    cd ${__DIR__}/chromium/chromium/src/

    git config branch.autosetupmerge always
    git config branch.autosetuprebase always
    git restore .
    git clean -fd
    # git rebase-update
    git checkout main
    if [ -f ".git/rebase-merge" ]; then
      rm -fr ".git/rebase-merge"
    fi
    # git pull origin main --depth=1 --rebase=true --allow-unrelated-histories --progress
    git pull origin main --depth=1 --rebase=true --progress
    #git fetch origin main --depth=1   --progress
    #git merge origin/main --allow-unrelated-histories
    # git rebase-update
    cd ${__DIR__}/chromium/chromium/
    # gclient sync --verbose --force

    gclient sync -D --verbose --nohooks --no-history --auto_rebase -R --shallow -j$(nproc)

    cd ${__DIR__}/chromium/chromium/src/
    git checkout main
    git merge origin/main
    git branch
    cd ${__DIR__}/chromium/chromium/
    gclient runhooks --verbose -j$(nproc) #--deps=linux

    #sed -i "s/= urlopen(url)/= urlopen(url,proxies={'http': os.environ.get('http_proxy')})/" ${__DIR__}/chromium/chromium/src/build/linux/sysroot_scripts/install-sysroot.py
    #python3 ${__DIR__}/chromium/chromium/src/build/linux/sysroot_scripts/install-sysroot.py --arch=amd64
    #python3 ${__DIR__}/chromium/chromium/src/tools/update_pgo_profiles.py --target linux get_profile_path

    cd ${__DIR__}/chromium/chromium/src/
    #git restore build/linux/sysroot_scripts/install-sysroot.py

    git clean -fd
  }
else
  {
    test -d ${__DIR__}/chromium/chromium/src/ && rm -rf ${__DIR__}/chromium/chromium/src/
    test -f ${__DIR__}/chromium/chromium/.gclient && rm -f ${__DIR__}/chromium/chromium/.gclient
    fetch --nohooks --no-history chromium
    gclient sync --nohooks --no-history
    gclient runhooks --deps=linux --verbose
  }
fi

cd ${__DIR__}/chromium/chromium/src
git branch
cd ${__DIR__}/

=
# git reset --merge
# git clean -fd

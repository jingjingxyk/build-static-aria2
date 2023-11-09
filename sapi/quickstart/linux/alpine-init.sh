#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

# use china mirror
# bash sapi/quickstart/linux/alpine-init.sh --mirror china


MIRROR=''
while [ $# -gt 0 ]; do
  case "$1" in
  --mirror)
    MIRROR="$2"
    ;;
  --*)
    echo "no found mirror option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

case "$MIRROR" in
china|tuna)
  test -f /etc/apk/repositories.save || cp /etc/apk/repositories /etc/apk/repositories.save
  sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
  ;;
ustc)
  test -f /etc/apk/repositories.save || cp /etc/apk/repositories /etc/apk/repositories.save
  sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
  ;;

esac

apk update

apk add vim alpine-sdk xz autoconf automake linux-headers clang-dev clang lld libtool cmake bison re2c gettext coreutils gcc g++

apk add bash zip unzip flex pkgconf ca-certificates
apk add tar gzip zip unzip bzip2

apk add bash 7zip
# apk add bash p7zip

apk add wget git curl

apk add libc++-static libltdl-static
apk add yasm nasm
apk add ninja python3 py3-pip
apk add diffutils
apk add netcat-openbsd
apk add python3-dev
apk add mercurial

case "$MIRROR" in
china|tuna)
  pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
  ;;
ustc)
  pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/web/simple
  ;;

esac


# pip3 install meson
apk add meson



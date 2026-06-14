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

# homepage
# https://www.fnnas.com/
# download fnos
# https://www.fnnas.com/download?key=fnos
# install fnos
# https://help.fnnas.com/articles/v1/start/install-os

ISO_FILE=fnos_Mainland-PE_x86_1.1.3107_1809.iso
SIGN="sign=a1f440bb167e2e9ecf61e087a36a0115&t=1781240883"

# curl -LSo ${ISO_FILE} "https://iso.liveupdate.fnnas.com/x86_64/trim/${ISO_FILE}?${SIGN}"

if [ -f runtime/aria2c/aria2c ]; then
  curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-aria2-runtime.sh?raw=ture | bash -s -- --mirror china
fi
export PATH="${__PROJECT__}/runtime/aria2c/:$PATH"
which aria2c

aria2c -o ${ISO_FILE} --file-allocation=none -c -x16 -s16 "https://iso.liveupdate.fnnas.com/x86_64/trim/${ISO_FILE}?${SIGN}"

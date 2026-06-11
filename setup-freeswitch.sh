#!/usr/bin/env bash
set -exu

__CURRENT__=$(pwd)
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

TOKEN=""
MIRROR=''
WITH_PREOXY=0
while [ $# -gt 0 ]; do
  case "$1" in
  --token)
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
    TOKEN="$2"
    WITH_PREOXY=1
    ;;
  --mirror)
    MIRROR="$2"
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

# https://developer.signalwire.com/freeswitch/FreeSWITCH-Explained/Installation/Linux/Debian_67240088/
# https://freeswitch.org/confluence/display/FREESWITCH/Debian

test -f /etc/apt/apt.conf.d/proxy.conf && rm -rf /etc/apt/apt.conf.d/proxy.conf

case "$MIRROR" in
china)
  sed -i "s@deb.debian.org@mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
  sed -i "s@security.debian.org@mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
  ;;

esac

echo "127.0.0.1 $HOSTNAME" >>/etc/hosts
hostname --fqdn

apt-get update && apt-get install -y gnupg2 wget lsb-release tini

wget --http-user=signalwire --http-password=$TOKEN -O /usr/share/keyrings/signalwire-freeswitch-repo.gpg https://freeswitch.signalwire.com/repo/deb/debian-release/signalwire-freeswitch-repo.gpg

echo "machine freeswitch.signalwire.com login signalwire password $TOKEN" >/etc/apt/auth.conf
echo "deb [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ $(lsb_release -sc) main" >/etc/apt/sources.list.d/freeswitch.list
echo "deb-src [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ $(lsb_release -sc) main" >>/etc/apt/sources.list.d/freeswitch.list

if [ ${WITH_PREOXY} -eq 0 ]; then

  cat >/etc/apt/apt.conf.d/proxy.conf <<EOF
  Acquire::http::Proxy "${HTTP_PROXY}";
  Acquire::https::Proxy "${HTTP_PROXY}";
EOF

fi

# you may want to populate /etc/freeswitch at this point.
# if /etc/freeswitch does not exist, the standard vanilla configuration is deployed
apt-get update && apt-get install -y freeswitch-meta-all --fix-broken

test -f /etc/apt/apt.conf.d/proxy.conf && rm -f /etc/apt/apt.conf.d/proxy.conf

# tini -- /usr/bin/freeswitch -c
# fs_cli -rRS

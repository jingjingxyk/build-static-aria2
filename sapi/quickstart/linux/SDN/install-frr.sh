#!/usr/bin/env bash
#set -euo pipefail

set -eux
set -o pipefail

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}

MIRROR=''
while [ $# -gt 0 ]; do
 case "$1" in
 --mirror)
   MIRROR="$2"
   ;;
 --proxy)
   export HTTP_PROXY="$2"
   export HTTPS_PROXY="$2"
   NO_PROXY="127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16"
   NO_PROXY="${NO_PROXY},127.0.0.1,localhost"
   NO_PROXY="${NO_PROXY},.aliyuncs.com,.aliyun.com"
   export NO_PROXY="${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn,.npmmirror.com,.tencent.com"
   ;;
 --*)
   echo "Illegal option $1"
   ;;
 esac
 shift $(($# > 0 ? 1 : 0))
done

OS_ID=$(cat /etc/os-release | grep '^ID=' | awk -F '=' '{print $2}')
VERSION_ID=$(cat /etc/os-release | grep '^VERSION_ID=' | awk -F '=' '{print $2}' | sed "s/\"//g")

if [ ${OS_ID} = 'debian'  ] || [ ${OS_ID} = 'ubuntu' ] ; then
    echo 'supported OS'
else
    echo 'no supported OS'
    exit 0
fi

# 推荐使用 ubuntu 构建

case "$MIRROR" in
china | tuna | ustc | aliyuncs )
      # 详情 http://mirrors.ustc.edu.cn/help/debian.html
      # 容器内和容器外 镜像源配置不一样
      if [ -f /.dockerenv ] && [ ${VERSION_ID} = 12 ] ; then
        test -f /etc/apt/sources.list.d/debian.sources.save || cp -f /etc/apt/sources.list.d/debian.sources /etc/apt/sources.list.d/debian.sources.save
        sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources
        sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources
        test "$MIRROR" = "tuna" && sed -i "s@mirrors.ustc.edu.cn@mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list.d/debian.sources
        test "$MIRROR" = "aliyuncs" && sed -i "s@mirrors.ustc.edu.cn@mirrors.cloud.aliyuncs.com@g" /etc/apt/sources.list.d/debian.sources
      else
        test -f /etc/apt/sources.list.save || cp -f /etc/apt/sources.list /etc/apt/sources.list.save
        sed -i "s@deb.debian.org@mirrors.ustc.edu.cn@g" /etc/apt/sources.list
        sed -i "s@security.debian.org@mirrors.ustc.edu.cn@g" /etc/apt/sources.list
        # ubuntu
        sed -i "s@security.ubuntu.com@mirrors.ustc.edu.cn@g" /etc/apt/sources.list
        sed -i "s@archive.ubuntu.com@mirrors.ustc.edu.cn@g" /etc/apt/sources.list
        test "$MIRROR" = "tuna" && sed -i "s@mirrors.ustc.edu.cn@mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
        test "$MIRROR" = "aliyuncs" && sed -i "s@mirrors.ustc.edu.cn@mirrors.cloud.aliyuncs.com@g" /etc/apt/sources.list
      fi
      ;;
esac

prepare(){

  apt update -y

  export LANG="en_US.UTF-8"
  export LC_ALL="en_US.UTF-8"
  export LC_CTYPE="en_US.UTF-8"
  export DEBIAN_FRONTEND=noninteractive
  export TZ="UTC"
  export TZ="Etc/UTC"
  export ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
  DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt install -y locales tzdata keyboard-configuration

  # localedef -i en_US -f UTF-8 en_US.UTF-8
  # dpkg-reconfigure locales

  apt install -y git curl python3 python3-pip python3-dev wget   sudo file
  apt install -y libssl-dev ca-certificates

  apt install -y  \
  git gcc clang make cmake autoconf automake openssl python3 python3-pip  libtool  \
  openssl  curl  libssl-dev  libcap-ng-dev uuid uuid-runtime


  apt install -y kmod iptables
  apt install -y netcat-openbsd
  apt install -y tcpdump nmap traceroute net-tools dnsutils iproute2 procps iputils-ping iputils-arping
  apt install -y conntrack
  apt install -y bridge-utils
  apt install -y libelf-dev  libbpf-dev # libxdp-dev
  apt install -y graphviz
  apt install -y libjemalloc2   libjemalloc-dev  libnuma-dev   libpcap-dev  libunbound-dev  libunwind-dev  llvm-dev
  apt install -y bc init ncat
  # apt install -y isc-dhcp-server


  apt install -y libjson-c-dev
  apt install -y libprotobuf-c-dev protobuf-c-compiler
  apt install -y libreadline-dev
  apt install -y libyang2-dev
  # apt install -y  libyang-dev
  apt install -y libcap-dev
  apt install -y sphinx
  apt install -y libbison-dev
  apt install -y yacc
  apt install -y python3-ply
  apt install -y flex
}

# test $(dpkg-query -l graphviz | wc -l) -eq 0 && prepare

test $(command -v ncat | wc -l) -eq 0 && prepare



CPU_NUMS=$(nproc)
CPU_NUMS=$(grep "processor" /proc/cpuinfo | sort -u | wc -l)

cd ${__DIR__}
if test -d frr
then
    cd ${__DIR__}/frr/
    git   pull --depth=1 --progress --rebase
else
    git clone -b frr-9.0.2 https://github.com/FRRouting/frr.git --depth=1 --progress
fi

cd ${__DIR__}



cd ${__DIR__}/frr/

sh bootstrap.sh
./configure --help
./configure


make -j $CPU_NUMS
make install


cd ${__DIR__}
rm -rf ${__DIR__}/frr

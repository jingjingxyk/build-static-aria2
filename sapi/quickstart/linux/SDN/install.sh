#!/usr/bin/env bash
#set -euo pipefail

set -eux
set -o pipefail


__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}


while [ $# -gt 0 ]; do
 case "$1" in
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


prepare(){

  sed -i "s@deb.debian.org@mirrors.ustc.edu.cn@g" /etc/apt/sources.list
  sed -i "s@security.debian.org@mirrors.ustc.edu.cn@g" /etc/apt/sources.list
  apt update -y

  apt install -y git curl python3 python3-pip python3-dev wget   sudo file
  apt install -y libssl-dev ca-certificates

  apt install -y  \
  git gcc clang make cmake autoconf automake openssl python3 python3-pip unbound libtool  \
  openssl netcat curl  graphviz libssl-dev  libcap-ng-dev uuid uuid-runtime
  apt install -y net-tools
  apt install -y kmod iptables

}
test $(dpkg-query -l graphviz | wc -l) -eq 0 && prepare



cpu_nums=$(nproc)
cpu_nums=$(grep "processor" /proc/cpuinfo | sort -u | wc -l)

if test -d ovn
then
    cd ${__DIR__}/ovn/
    git   pull --depth=1 --progress --rebase
    cd ${__DIR__}/ovs/
    git   pull --depth=1 --progress --rebase
else
    git clone -b master https://github.com/openvswitch/ovs.git --depth=1 --progress
    git clone -b main https://github.com/ovn-org/ovn.git --depth=1 --progress
fi

cd ${__DIR__}/ovs/
./boot.sh
cd ${__DIR__}/ovs/


./configure --enable-ssl
make -j $cpu_nums
sudo make install

cd ${__DIR__}/ovn/

#test -d build &&  rm -rf build
#mkdir build
./boot.sh
cd ${__DIR__}/ovn/
./configure  --enable-ssl \
--with-ovs-source=${__DIR__}/ovs/ \
--with-ovs-build=${__DIR__}/ovs/

make -j $cpu_nums
sudo make install


cd ${__DIR__}
rm -rf ${__DIR__}/ovn
rm -rf ${__DIR__}/ovs

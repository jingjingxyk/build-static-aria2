#!/usr/bin/env bash

set -x
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

__PROJECT__=$(
  cd ${__DIR__}/../../../../
  pwd
)
cd ${__PROJECT__}
mkdir -p ${__PROJECT__}/var/kubernetes/
cd ${__PROJECT__}/var/kubernetes/

while [ $# -gt 0 ]; do
  case "$1" in
  --proxy)
    export HTTP_PROXY="$2"
    export HTTPS_PROXY="$2"
    NO_PROXY="127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16"
    NO_PROXY="${NO_PROXY},127.0.0.1,localhost"
    NO_PROXY="${NO_PROXY},.aliyuncs.com,.aliyun.com"
    NO_PROXY="${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn"
    NO_PROXY="${NO_PROXY},.tencent.com"
    NO_PROXY="${NO_PROXY},.sourceforge.net"
    NO_PROXY="${NO_PROXY},.npmmirror.com"
    export NO_PROXY="${NO_PROXY}"
    ;;

  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

# shellcheck disable=SC2034
OS=$(uname -s)
# shellcheck disable=SC2034
ARCH=$(uname -m)


mkdir -p kube-ovn
cd kube-ovn

# 从 Kube-OVN v1.12.0 版本开始，支持 Helm Chart 安装，默认部署为 Overlay 类型网络。
# CNI kube-ovn
# https://github.com/kubeovn/kube-ovn?tab=readme-ov-file
# https://kubeovn.github.io/docs/stable/start/one-step-install/
# https://github.com/kubeovn/kube-ovn/tags
VERSION="release-1.13"

curl -fSLo kube-ovn-${VERSION}-install.sh https://raw.githubusercontent.com/kubeovn/kube-ovn/${VERSION}/dist/images/install.sh
curl -fSLo kube-ovn-${VERSION}-uninstall.sh https://raw.githubusercontent.com/kubeovn/kube-ovn/${VERSION}/dist/images/cleanup.sh
curl -fSLo kubectl-ko https://raw.githubusercontent.com/kubeovn/kube-ovn/${VERSION}/dist/images/kubectl-ko
unset HTTP_PROXY
unset HTTPS_PROXY




bash kube-ovn-${VERSION}-install.sh

ip route show

# 卸载 和 清理残余

cat >kube-ovn-${VERSION}-clean.sh <<EOF
rm -rf /var/run/openvswitch
rm -rf /var/run/ovn
rm -rf /etc/origin/openvswitch/
rm -rf /etc/origin/ovn/
rm -rf /etc/cni/net.d/00-kube-ovn.conflist
rm -rf /etc/cni/net.d/01-kube-ovn.conflist
rm -rf /var/log/openvswitch
rm -rf /var/log/ovn
rm -fr /var/log/kube-ovn

# reboot

EOF


# kubectl-ko more info
# https://kubeovn.github.io/docs/stable/ops/kubectl-ko/


mv kubectl-ko /usr/local/bin/kubectl-ko

chmod +x /usr/local/bin/kubectl-ko

kubectl plugin list

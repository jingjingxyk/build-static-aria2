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

# Kubernetes Dashboard 从版本 7.0.0 开始仅支持基于 Helm 的安装

helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard

exit 0


kubectl -n kubernetes-dashboard get svc

# To access Dashboard run:
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443

# https://localhost:8443

exit 0

# docs
https://github.com/kubernetes/dashboard/blob/master/docs/user/accessing-dashboard/README.md

exit 0

# https://github.com/kubernetes/dashboard/tags
VERSION="v2.7.0"
VERSION="v3.0.0-alpha0"

curl -L -O https://raw.githubusercontent.com/kubernetes/dashboard/${VERSION}/charts/kubernetes-dashboard.yaml

kubectl create -f kubernetes-dashboard.yaml

# kubectl create -f kubernetes-dashboard-sample-user.yaml

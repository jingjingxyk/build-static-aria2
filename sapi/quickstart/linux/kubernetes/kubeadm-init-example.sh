#!/usr/bin/env bash

export PATH=$PATH:/usr/sbin/

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# 设置所需的 sysctl 参数，参数在重新启动后保持不变
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
net.ipv6.ip_forward                 = 1
net.ipv6.conf.all.forwarding        = 1
EOF

# 应用 sysctl 参数而不重新启动
sudo sysctl --system

lsmod | grep br_netfilter
lsmod | grep overlay

# 验证设置结果
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward net.ipv6.conf.all.forwarding

CRI_SOCKET="unix:///var/run/containerd/containerd.sock"
while [ $# -gt 0 ]; do
  case "$1" in
  --cri-socket)
    case "$2" in
    dockerd)
      CRI_SOCKET="unix:///var/run/cri-dockerd.sock"
      ;;
    containerd)
      CRI_SOCKET="unix:///var/run/containerd/containerd.sock"
      ;;
    esac
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

# export CONTAINER_RUNTIME_ENDPOINT="unix:///run/containerd/containerd.sock"
# export KUBECONFIG=/etc/kubernetes/admin.conf

export KUBE_PROXY_MODE=ipvs

# https://dl.k8s.io/release/stable-1.txt

kubeadm config images list --v=5 --kubernetes-version=$(kubelet --version | awk -F ' ' '{print $2}')
kubeadm config images pull --v=5 --kubernetes-version=$(kubelet --version | awk -F ' ' '{print $2}') --cri-socket ${CRI_SOCKET}

ip route show | grep -E '^default'

NIC=$(ip link | grep eth0)
if [ $? -ne 0 ]; then
  NIC=$(ip link | grep enp0s3)
fi

if [ -z "${NIC}" ]; then
  echo 'no found NIC'
  exit 0
fi

IP=$(ip address show | grep ${NIC} | grep 'inet' | awk '{print $2}' | awk -F '/' '{print $1}')

echo $IP

swapoff -a
export KUBE_PROXY_MODE=ipvs
kubeadm init \
  --kubernetes-version=$(kubelet --version | awk -F ' ' '{print $2}') \
  --pod-network-cidr=10.244.0.0/16,fd00:11::/64 \
  --service-cidr=10.96.0.0/16,fd00:22::/112 \
  --token-ttl 0 \
  --v=5 \
  --cri-socket ${CRI_SOCKET} \
  --apiserver-advertise-address="${IP}"

# --control-plane-endpoint='control-plane-endpoint-api.intranet.jingjingxyk.com:6443'
# --apiserver-advertise-address="${ip}"

# --cri-socket "unix:///var/run/containerd/containerd.sock"
# --cri-socket "unix:///var/run/cri-dockerd.sock"

mkdir -p $HOME/.kube
cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

kubectl taint nodes --all node-role.kubernetes.io/control-plane-

# https://github.com/kubernetes/kubernetes/blob/master/pkg/proxy/ipvs/README.md
#  enable ipvs mod
# kubectl edit configmap kube-proxy -n kube-system
## change mode from "" to ipvs
## mode: ipvs

lsmod | grep -e ip_vs -e nf_conntrack_ipv4

ipvsadm -ln
iptables -t nat -nL

kubeadm token list

openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null |
  openssl dgst -sha256 -hex | sed 's/^.* //'

# create cluster

# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

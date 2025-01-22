# 自建  kubernetes v1.28

[kubernetes container-runtimes](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd)

https://kubernetes.io/zh-cn/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

[containerd getting started](https://github.com/containerd/containerd/blob/main/docs/getting-started.md)

[ crictl ](https://github.com/kubernetes-sigs/cri-tools/blob/master/docs/crictl.md)

[containerd releases ](https://github.com/containerd/containerd/releases)

[containerd image mirroring](https://github.com/kubernetes/registry.k8s.io/blob/main/docs/mirroring/containerd.md)

[runc release ](https://github.com/opencontainers/runc/releases)

[cni-plugins](https://github.com/containernetworking/plugins/releases)

[projectcalico/calico](https://github.com/projectcalico/calico.git)
[projectcalico/calico manifest ](https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises)

[kubernetes accessing-dashboard](https://github.com/kubernetes/dashboard)
[kubernetes accessing-dashboard](https://github.com/kubernetes/dashboard/blob/master/docs/user/accessing-dashboard/README.md)
[kubernetes dashboard creating-sample-user ](https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md)

[metrics-server](https://github.com/kubernetes-sigs/metrics-server)

[nginx ingress](https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal-clusters)

[kubernets ipvs](https://github.com/kubernetes/kubernetes/blob/master/pkg/proxy/ipvs/README.md)

[网络插件 kubernets networking addons (calico CNI-Genie  kube-ovn Multus)](https://kubernetes.io/docs/concepts/cluster-administration/addons/)

```bash

kubeadm config images list

kubeadm init --image-repository=registry.k8s.io

journalctl -f


kubectl get pod --all-namespaces

crictl images
crictl pods
crictl ps



journalctl -xe


```

## debian restart networking

```bash

systemctl restart networking

```

## container registry

```bash

#  docker.io (docker hub公共镜像库)
#  gcr.io (Google container registry)
#  registry.k8s.io (等同于gcr.io/google-containers)
#  quay.io (Red Hat运营的镜像库)
#  ghcr.io (github 运营的镜像库)

# Registry Explorer
# https://explore.ggcr.dev/


dockerd --debug

```

## enable ipvs mod

```bash

kubectl edit configmap kube-proxy -n kube-system

```

```text
#  enable ipvs mod

   ## change mode from "" to ipvs
   ## mode: ipvs

```

## ingress-nginx nodeport

```bash

kubectl edit service/ingress-nginx-controller  -n ingress-nginx

```

```yaml

type: NodePort
externalIPs:
  - 192.168.3.26
externalTrafficPolicy: Local


```

## restart pod

```bash

kubectl rollout restart deployment <deployment-name>

kubectl rollout restart statefulset <statefulset-name>

kubectl delete pod <pod-name>

```


## Kubernetes 使用的端口和协议
https://kubernetes.io/zh-cn/docs/reference/networking/ports-and-protocols/

https://www.kubesphere.io/zh/docs/v4.1/03-installation-and-upgrade/01-preparations/01-supported-k8s/
https://www.kubesphere.io/zh/docs/v4.1/03-installation-and-upgrade/02-install-kubesphere/02-install-kubernetes-and-kubesphere/


```shell

journalctl -u kubelet

```

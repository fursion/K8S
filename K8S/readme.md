# K8S 架构

    kubctl kubeadm

## [官方文档](https://kubernetes.io/zh-cn/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

## 环境准备

### EVN

    k8s-master 172.16.172.128
    k8s-node01
    k8s-node02 172.16.172.130
检查docker版本、关闭防火墙及Selinux、清空iptables规则、禁用Swap交换分区

```shell
    docker -v #检查docker版本
    #centos 关闭防火墙
    systemctl stop firewalld
    systemctl disbale firewalld
    #ubuntu关闭防火墙
    sudo ufw disable
    #清空iptables规则
    sudo iptables -F
    #禁用Swap交换分区
    sudo swapoff -a
    #编辑fstab文件 修改如下
    sudo vim /etc/fstab
    #/swap.img      none    swap    sw      0       0
```

## 安装kubeadm、kubelet、kubectl

- kubeadm：用来初始化集群的指令。

- kubelet：在集群中的每个节点上用来启动 Pod 和容器等。

- kubectl：用来与集群通信的命令行工具。

1. 更新 apt 包索引并安装使用 Kubernetes apt 仓库所需要的包：

```bash
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl
```

2. 下载 Google Cloud 公开签名秘钥：

```bash
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
```

3. 添加 Kubernetes apt 仓库：

```bash
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

4. 更新 apt 包索引，安装 kubelet、kubeadm 和 kubectl，并锁定其版本：

```bash
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

## 配置 kubelet 的 cgroup 驱动

```
# kubeadm-config.yaml
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta3
kubernetesVersion: v1.21.0
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
```

### 安装容器运行时

#### 安装docker-ce 和 cri-dockerd

```bash
sudo apt update 
sudo apt install apt-transport-https ca-certificates curl software-properties-common 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" 
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce 
sudo systemctl status docker 
```

#### containerd

### 初始化控制平面节点

#### 安装Pod网络插件

```bash
wget https://docs.projectcalico.org/manifests/calico.yaml
kubectl apply -f kube-flannel.yml
```

#### 初始化

```bash
sudo kubeadm init --pod-network-cidr=172.16.0.0/16 --cri-socket /var/run/cri-dockerd.sock
#初始化之后需要做的

```

#### 加入工作节点
重新生成加入凭证
kubeadm token create --print-join-command
```bash
sudo kubeadm join 172.16.172.128:6443 --token oszbr0.9wut33vjklo5ek8d --discovery-token-ca-cert-hash sha256:f5624c3c2e7fdb16d158a1ba45b511e3425f55f8a5c1b23fb456b663eeee019d --cri-socket /var/run/cri-dockerd.sock --cri-socket /var/run/cri-dockerd.sock
```

#### [Node节点重置](/K8S_Install.sh)
```bash
kubeadm reset
systemctl stop kubelet
systemctl stop docker
rm -rf /var/lib/cni/
rm -rf /var/lib/kubelet/*
rm -rf /etc/cni/
##重启kubelet
systemctl restart kubelet
##重启docker
systemctl restart docker
```

### [kubeadm故障排查手册](https://kubernetes.io/zh-cn/docs/setup/production-environment/tools/kubeadm/troubleshooting-kubeadm/)

### 内核参数调整

```bash
cat > kubernetes <<EOF
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv6.conf.all.disable_ipv6=1
EOF
cp kubernetes.conf /etc/sysctl.d/kubernetes.conf
sysctl -p /etc/sysctl.d/kubernetes.conf
```

### 时区调整

```bash
#设置时区
sudo timedatectl set-timezone Asia/Shanghai
sudo timedatectl set-local-rtc 0
sudo systemctl restart rsyslog
sudo systemctl restart crond
```

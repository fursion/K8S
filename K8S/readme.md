# K8S 架构

    kubctl kubeadm

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
```

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

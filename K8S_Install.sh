#! /bin/bash
#关闭防火墙
#sudo ufw disable
#清空iptables规则
#sudo iptables -F

#安装Docker
function Install_docker() {
    echo "$1" # arguments are accessible through $1, $2,...
}
function install_k8s() {
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl
}

#环境检查和设置
function EnvCheck() {
    p=$(uname -a)
    echo "$p"
    ufws=$(ufw status)
    echo "$1" # arguments are accessible through $1, $2,...

}
function main() {
    Errlog "此脚本只适用于ubuntu系统"
    EnvCheck
}
function Errlog() {
    echo -e "\033[31m$1\033[37m"
}

main

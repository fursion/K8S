#! /bin/bash
#关闭防火墙
#sudo ufw disable
#清空iptables规则
#sudo iptables -F

#安装Docker
function Install_docker () {
    echo "$1" # arguments are accessible through $1, $2,...
}
#环境检查和设置
function EnvCheck () {
    p=$(uname -a)
    echo "$p"
   
    echo "$1" # arguments are accessible through $1, $2,...

}
function main () {
    EnvCheck
}
main
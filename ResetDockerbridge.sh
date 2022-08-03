#! /bin/bash
sudo apt install -y bridge-utils
sudo systemctl stop docker
sudo ip link set dev docker0 down
sudo brctl delbr docker0
sudo systemctl start docker
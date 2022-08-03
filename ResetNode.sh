#!/bin/bash
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
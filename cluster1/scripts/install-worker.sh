#!/bin/sh
echo
echo
echo "[*] Running install-worker.sh"
echo

kubeadm reset -f
sh /vagrant/tmp/master-join-command.sh
systemctl daemon-reload
service kubelet start

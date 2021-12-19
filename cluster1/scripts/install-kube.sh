#!/bin/sh

# Source: http://kubernetes.io/docs/getting-started-guides/kubeadm/

echo
echo
echo "[*] Running install-kube.sh"
echo

for i in docker.io kubelet kubeadm kubectl kubernetes-cni; do
  if apt -qq list $i | grep -qs installed; then
    apt remove -y $i
  fi
done
# apt-get remove -y docker.io kubelet kubeadm kubectl kubernetes-cni
apt-get autoremove -y
systemctl daemon-reload
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
swapoff -a
apt-get update
export KUBE_VERSION=1.22.2-00
apt-get install -y docker.io kubelet=${KUBE_VERSION} kubeadm=${KUBE_VERSION} kubectl=${KUBE_VERSION} kubernetes-cni
apt-mark hold kubelet kubeadm kubectl
cat >/etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "storage-driver": "overlay2"
}
EOF
mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker

# start docker on reboot
systemctl enable docker

docker info | grep -i "storage"
docker info | grep -i "cgroup"

systemctl enable kubelet && systemctl start kubelet

exit 0

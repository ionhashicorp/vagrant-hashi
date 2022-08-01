#!/usr/bin/env bash

echo "[TASK 1] Pull required containers"
kubeadm config images pull >/dev/null 2>&1

echo "[TASK 2] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=192.168.56.51 --pod-network-cidr=10.5.0.0/16 >> /root/kubeinit.log 2>/dev/null

# echo "[TASK 3] Deploy Calico network"
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/manifests/calico.yaml >/dev/null 2>&1

echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh 2>/dev/null

echo "[TASK 5] Add kubectl config"
mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config
kubectl completion bash >> /home/vagrant/.bashrc

echo "[TASK 6 Install Helm]"
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

echo "[TASK 7] Install consul-k8s"
curl -o consul-k8s.zip -sSL https://releases.hashicorp.com/consul-k8s/0.46.1/consul-k8s_0.46.1_linux_amd64.zip
which unzip || apt install -qq -y unzip
unzip consul-k8s.zip && rm consul-k8s.zip
chown vagrant:vagrant consul-k8s
mv consul-k8s /usr/local/bin
#!/usr/bin/env bash

# CNI plugin - nomad consul integration
# https://www.nomadproject.io/docs/integrations/consul-connect#cni-plugins

# internet reachable? before continue
for i in {1..15}; do ping -c1 www.google.com &> /dev/null && break; done

# install
curl -L -o cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v1.0.0/cni-plugins-linux-$( [ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)"-v1.0.0.tgz
sudo mkdir -p /opt/cni/bin
sudo tar -C /opt/cni/bin -xzf cni-plugins.tgz


# enable on startup
tee /etc/sysctl.d/50-nomad-consul-cni-bridge.conf > /dev/null <<EOT
net.bridge.bridge-nf-call-arptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOT
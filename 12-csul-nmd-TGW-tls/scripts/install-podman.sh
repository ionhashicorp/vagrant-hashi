#!/usr/bin/env bash

# internet reachable? before continue
for i in {1..15}; do ping -c1 www.google.com &> /dev/null && break; done

# install podman
apt-get update
apt-get -qq -y install podman

systemctl start podman

# plugin podman for nomad
curl -o nomad-driver-podman.zip -sSL https://releases.hashicorp.com/nomad-driver-podman/0.4.0/nomad-driver-podman_0.4.0_linux_amd64.zip
which unzip || apt-get install -qq -y unzip
unzip nomad-driver-podman.zip
mkdir -p /opt/nomad/plugins
mv nomad-driver-podman /opt/nomad/plugins
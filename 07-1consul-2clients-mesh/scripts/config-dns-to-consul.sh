#!/usr/bin/env bash

# https://learn.hashicorp.com/tutorials/consul/dns-forwarding?in=consul/networking

mkdir -p /etc/systemd/resolved.conf.d/

tee /etc/systemd/resolved.conf.d/consul.conf > /dev/null <<EOT
[Resolve]
DNS=127.0.0.1:8600
DNSSEC=false
Domains=~consul

EOT

# restart systemd-resolved to take effect
systemctl restart systemd-resolved

# test manually if needed
# resolvectl domain
# resolvectl query consul.service.consul

# serve any DNS queryes, not only localhost
# https://learn.hashicorp.com/tutorials/consul/dns-forwarding?in=consul/networking#using-any-local-resolver-with-systemd

tee -a /etc/systemd/resolved.conf > /dev/null <<EOF

DNSStubListener=false
EOF


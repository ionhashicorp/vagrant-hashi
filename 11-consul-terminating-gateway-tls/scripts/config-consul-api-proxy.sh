#!/usr/bin/env bash

tee /etc/systemd/system/api-proxy.service > /dev/null <<EOF
[Unit]
Description=Consul Service Mesh Envoy Proxy for API-SERVICE
After=network.target consul.service
Requires=consul.service
ConditionPathExists=/etc/consul.d/api-service.hcl

[Service]
Type=simple
ExecStart=/usr/bin/consul connect envoy -sidecar-for=api-service -- -l debug
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl enable api-proxy
systemctl start api-proxy
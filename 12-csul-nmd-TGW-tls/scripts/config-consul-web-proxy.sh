#!/usr/bin/env bash

tee /etc/systemd/system/web-proxy.service > /dev/null <<EOF
[Unit]
Description=Consul Service Mesh Envoy Proxy for WEB-SERVICE
After=network.target consul.service
Requires=consul.service
ConditionPathExists=/etc/consul.d/web-service.hcl

[Service]
Type=simple
ExecStart=/usr/bin/consul connect envoy -sidecar-for=web-service -- -l debug
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl enable web-proxy
systemctl start web-proxy
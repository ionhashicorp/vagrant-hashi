#!/usr/bin/env bash

tee /etc/systemd/system/tgw-proxy.service > /dev/null <<EOF
[Unit]
Description=Consul Terminating Gateway
After=network.target consul.service
Requires=consul.service


[Service]
Type=simple
ExecStart=/usr/bin/consul connect envoy -gateway=terminating -register -service external_database_virtual_consul_node -address '{{ GetInterfaceIP "enp0s8" }}:8443' -- -l debug
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl enable tgw-proxy
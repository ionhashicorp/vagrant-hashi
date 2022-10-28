#!/usr/bin/env bash

tee /etc/systemd/system/web.service > /dev/null <<EOF
[Unit]
Description=WEB
After=syslog.target network.target

[Service]
Environment="MESSAGE=WEB-WEB-WEB"
Environment="NAME=WEB"
Environment="LISTEN_ADDR=0.0.0.0:9090"

Environment="UPSTREAM_URIS=http://localhost:9091"
ExecStart=/usr/local/bin/fake-service
ExecStop=/bin/sleep 5
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl enable web
systemctl start web
#!/usr/bin/env bash

tee /etc/systemd/system/web.service > /dev/null <<EOF
[Unit]
[Unit]
Description=API
After=syslog.target network.target

[Service]
Environment="MESSAGE=API API API"
Environment="NAME=API"
Environment="LISTEN_ADDR=0.0.0.0:8080"
Environment="UPSTREAM_URIS=http://localhost:9003"
ExecStart=/usr/local/bin/fake-service
ExecStop=/bin/sleep 5
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl enable web
systemctl start web
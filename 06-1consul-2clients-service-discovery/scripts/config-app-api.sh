#!/usr/bin/env bash

# install API
tee /etc/systemd/system/api.service > /dev/null <<EOT
[Unit]
Description=API
After=syslog.target network.target

[Service]
Environment="MESSAGE=API API"
Environment="NAME=API"
ExecStart=/usr/local/bin/fake-service
ExecStop=/bin/sleep 5
Restart=always

[Install]
WantedBy=multi-user.target
EOT


systemctl daemon-reload
systemctl start api.service


# Register service in consul
tee /etc/consul.d/api.hcl > /dev/null <<EOT
service {
  name = "api"
  port = 9090
  
  checks {
    id = "api"
    name = "HTTP API on Port 9090"
    http = "http://localhost:9090/health"
    interval = "30s"
  }
}
EOT

chown consul:consul /etc/consul.d/api.hcl
systemctl reload consul
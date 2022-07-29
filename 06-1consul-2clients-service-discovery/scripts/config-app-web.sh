#!/usr/bin/env bash

# install WEB
tee /etc/systemd/system/web.service > /dev/null <<EOT
[Unit]
Description=WEB
After=syslog.target network.target

[Service]
Environment="MESSAGE=WEB-WEB-WEB"
Environment="NAME=WEB"
Environment="UPSTREAM_URIS=http://api.service.consul:9090"
ExecStart=/usr/local/bin/fake-service
ExecStop=/bin/sleep 5
Restart=always

[Install]
WantedBy=multi-user.target
EOT

systemctl daemon-reload
systemctl start web.service


# register api service in consul
tee /etc/consul.d/web.hcl > /dev/null <<EOT
service {
  name = "web"
  port = 9090
  check {
    id = "web"
    name = "HTTP Web on port 9090"
    http = "http://localhost:9090/health"
    interval = "30s"
  }
}
EOT

chown consul:consul /etc/consul.d/web.hcl

systemctl reload consul
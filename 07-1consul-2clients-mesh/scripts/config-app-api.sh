#!/usr/bin/env bash

# install API
tee /etc/systemd/system/api.service > /dev/null <<EOT
[Unit]
Description=API
After=syslog.target network.target

[Service]
Environment="MESSAGE=API API API"
Environment="NAME=API"
Environment="LISTEN_ADDR=0.0.0.0:8080"
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
  port = 8080

  connect {
    sidecar_service {}
  }
  
  checks {
    id = "api"
    name = "API on Port 8080"
    http = "http://localhost:8080/health"
    interval = "30s"
  }
}
EOT

chown consul:consul /etc/consul.d/api.hcl
systemctl reload consul

# Consul start envoy sidecar-proxy for web
tee /etc/systemd/system/api-envoy-proxy.service > /dev/null <<EOT
[Unit]
Description=Consul Envoy API
After=syslog.target network.target

[Service]
ExecStart=/usr/bin/consul connect envoy -sidecar-for api
ExecStop=/bin/sleep 5
Restart=always

[Install]
WantedBy=multi-user.target
EOT

systemctl daemon-reload
systemctl start api-envoy-proxy.service
#!/usr/bin/env bash

# install WEB
tee /etc/systemd/system/web.service > /dev/null <<EOT
[Unit]
Description=WEB
After=syslog.target network.target

[Service]
Environment="MESSAGE=WEB-WEB-WEB"
Environment="NAME=WEB"
Environment="UPSTREAM_URIS=http://localhost:5000"
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

  connect {
    sidecar_service {
      proxy {
        upstreams = [
          {
            destination_name = "api"
            local_bind_port  = 5000
          }
        ]
      }
    }
  }

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


# web - envoy proxy
tee /etc/systemd/system/web-envoy-proxy.service > /dev/null <<EOT
[Unit]
Description=Consul Envoy WEB
After=syslog.target network.target

[Service]
ExecStart=/usr/bin/consul connect envoy -sidecar-for web
ExecStop=/bin/sleep 5
Restart=always

[Install]
WantedBy=multi-user.target
EOT

systemctl daemon-reload
systemctl start web-envoy-proxy.service
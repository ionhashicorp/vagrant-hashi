#!/usr/bin/env bash

tee /etc/consul.d/web-service.hcl > /dev/null << EOF
service {
  name = "web-service"
  port = 9090

  check {
    name = "HTTP WEB on port 9090"
    http = "http://localhost:9090/health"
    interval ="10s"
  }

  connect { 
    sidecar_service {
      port = 20000

      check {
        name     = "Connect Envoy Sidecar"
        tcp      = "127.0.0.1:20000"
        interval = "10s"
      }

      proxy {
        upstreams {
          destination_name = "api-service"
          local_bind_address = "127.0.0.1"
          local_bind_port = 9091
        }
      }
    }
  }
}
EOF

systemctl reload consul
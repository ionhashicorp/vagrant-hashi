#!/usr/bin/env bash

tee /etc/consul.d/api-service.hcl > /dev/null << EOF
service {
  name = "api-service"
  port = 8080

  check {
    name = "HTTP API on port 8080"
    http = "http://localhost:8080/health"
    interval = "10s"
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
          destination_name = "external_database"
          local_bind_address = "127.0.0.1"
          local_bind_port = 9003
        }
      }

    }
  }
}
EOF

systemctl reload consul
#!/usr/bin/env bash

PRIVATE_IP=$(hostname -I | awk '{print $2}')

# snapshot agent
mkdir -p /opt/nomad/snapshots/
tee /etc/nomad-snapshot.hcl > /dev/null <<EOF
nomad {
  address         = "http://$PRIVATE_IP:4646"
}

snapshot {
  interval         = "10m"
  retain           = 30
  stale            = true
  service          = "nomad-snapshot"
  deregister_after = "72h"
  lock_key         = "nomad-snapshot/lock"
  max_failures     = 3
  prefix           = "nomad"
}

log {
  level           = "DEBUG"
  enable_syslog   = true
  syslog_facility = "LOCAL0"
}

consul {
  enabled         = true
  http_addr       = "127.0.0.1:8500"
  datacenter      = "dc1"
}

local_storage {
  path = "/opt/nomad/snapshots/"
}
EOF

tee /etc/systemd/system/nomad-snapshot.service > /dev/null <<EOF
[Unit]
Description=API
After=syslog.target network.target

[Service]
ExecStart=/usr/bin/nomad operator snapshot agent /etc/nomad-snapshot.hcl
ExecStop=/bin/sleep 5
Restart=always

[Install]
WantedBy=multi-user.target
EOF


# start nomad-agent-snapshot
systemctl enable nomad-snapshot
systemctl start nomad-snapshot
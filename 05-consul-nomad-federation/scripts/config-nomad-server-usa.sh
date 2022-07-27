#!/usr/bin/env bash

# nomad installed before configuration
while [ ! -f /usr/bin/nomad ]; do sleep 1; done

# empty default config
echo "" | tee /etc/nomad.d/nomad.hcl

# find local IP, transform x.y.z.w => x-y-z-w (to avoid dns issues)
PRIVATE_IP=$(hostname -I | awk '{print $2}' | sed "s/\./-/g")  
PRIVATE_IP_DASH=$(echo $PRIVATE_IP | sed "s/\./-/g")                  # sed "s/[original]/[target]/g", "s" means "substitute", "g" means "global, all matching occurrences"

# nomad server
tee /etc/nomad.d/nomad.hcl > /dev/null <<EOF
# nomad server config
name       = "nomad-usa-$PRIVATE_IP_DASH"
data_dir   = "/opt/nomad"

region     = "usa"
datacenter = "usa-dc1"

bind_addr = "{{ GetInterfaceIP \"enp0s8\" }}"

enable_debug=true

server {
  enabled = true
  raft_protocol = 3

  authoritative_region = "emea"
  
  bootstrap_expect = 1

  server_join {
    retry_join = ["192.168.56.101", "192.168.56.103", "192.168.56.102", "192.168.56.11:4648", "192.168.56.13:4648", "192.168.56.12:4648"]
    retry_max = 5
    retry_interval = "15s"
  }

  license_path = "/vagrant/licenses/nomad.hclic"
}

consul {
  address = "127.0.0.1:8500"
}
EOF

# start nomad
systemctl enable nomad
systemctl start nomad
#!/usr/bin/env bash

# nomad installed before configuration
while [ ! -f /usr/bin/nomad ]; do sleep 1; done

# license
tee /etc/nomad.d/nomad.hclic > /dev/null <<EOF
${nomad_license}
EOF

# empty default config
echo "" | tee /etc/nomad.d/nomad.hcl

# find local IP, transform x.y.z.w => x-y-z-w (to avoid dns issues)
PRIVATE_IP=$(hostname -I | awk '{print $2}' | sed "s/\./-/g")  
PRIVATE_IP_DASH=$(echo $PRIVATE_IP | sed "s/\./-/g")                  # sed "s/[original]/[target]/g", "s" means "substitute", "g" means "global, all matching occurrences"

# nomad server
tee /etc/nomad.d/nomad.hcl > /dev/null <<EOF
# nomad server config
name       = "nomad-$PRIVATE_IP_DASH"
datacenter = "dc1"
data_dir   = "/opt/nomad"

bind_addr = "{{ GetInterfaceIP \"enp0s8\" }}"

leave_on_terminate = true

server {
  enabled = true
  raft_protocol = 3
  bootstrap_expect = 3
  
  server_join {
    retry_join = ["192.168.56.11", "192.168.56.13", "192.168.56.12"]
    retry_max = 5
    retry_interval = "15s"
  }

  # if OSS binary is used then the license configuration is ignored
  license_path = "/vagrant/licenses/nomad.hclic"
}

consul {
  address = "127.0.0.1:8500"
}
EOF

# start nomad
systemctl enable nomad
systemctl start nomad
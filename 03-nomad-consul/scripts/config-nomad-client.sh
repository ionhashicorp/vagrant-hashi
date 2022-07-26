#!/usr/bin/env bash

# nomad installed before configuration
while [ ! -f /usr/bin/nomad ]; do sleep 1; done

# empty default config
echo "" | tee /etc/nomad.d/nomad.hcl

# find local IP, transform x.y.z.w => x-y-z-w (to avoid dns issues)
PRIVATE_IP=$(hostname -I | awk '{print $2}' | sed "s/\./-/g")  
PRIVATE_IP_DASH=$(echo $PRIVATE_IP | sed "s/\./-/g")                  # sed "s/[original]/[target]/g", "s" means "substitute", "g" means "global, all matching occurrences"

# nomad client
tee /etc/nomad.d/nomad.hcl > /dev/null <<EOF
# nomad client config
name       = "nomad-$PRIVATE_IP_DASH"
datacenter = "dc1"
data_dir   = "/opt/nomad"

bind_addr = "{{ GetInterfaceIP \"enp0s8\" }}"

client {
  enabled = true

  server_join {
    retry_join = ["192.168.56.11", "192.168.56.13", "192.168.56.12"]
    retry_max = 5
    retry_interval = "15s"
  }
  
  options = {
    "driver.raw_exec" = "1"
    "driver.raw_exec.enable" = "1"
  }
}

consul {
  address = "127.0.0.1:8500"
}
EOF

# start nomad
systemctl enable nomad
systemctl start nomad
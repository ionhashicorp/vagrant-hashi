#!/usr/bin/env bash

# consul installed before configuration
while [ ! -f /usr/bin/consul ]; do sleep 1; done

# empty default config
echo "" | tee /etc/consul.d/consul.hcl

# find local IP, transform x.y.z.w => x-y-z-w (to avoid dns issues)
PRIVATE_IP=$(hostname -I | awk '{print $2}' | sed "s/\./-/g")  
PRIVATE_IP_DASH=$(echo $PRIVATE_IP | sed "s/\./-/g")                  # sed "s/[original]/[target]/g", "s" means "substitute", "g" means "global, all matching occurrences"

# consul server
tee /etc/consul.d/consul.hcl > /dev/null <<EOF
# consul server config
node_name  = "consul-usa-$PRIVATE_IP_DASH"
data_dir   = "/opt/consul"

datacenter = "usa-dc1"

bind_addr   = "{{ GetInterfaceIP \"enp0s8\" }}"
client_addr = "0.0.0.0"

server           = true
raft_protocol    = 3

bootstrap_expect = 1
retry_join       = [ "192.168.56.101", "192.168.56.102", "192.168.56.103" ]
retry_join_wan   = [ "192.168.56.11", "192.168.56.12", "192.168.56.13"]
retry_interval   = "30s" 
retry_max        = 10

license_path     = "/vagrant/licenses/consul.hclic"

# Consul UI
ui_config {
  enabled = true
}

# service mesh
connect {
  enabled = true
}
addresses {
  grpc = "127.0.0.1"
}
ports {
  grpc = 8502
}
EOF

# start consul
systemctl enable consul
systemctl start consul
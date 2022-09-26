#!/usr/bin/env bash

# consul installed before configuration
while [ ! -f /usr/bin/consul ]; do sleep 1; done

# license
# tee /etc/consul.d/consul.hclic > /dev/null <<EOF
# ${consul_license}
# EOF

# empty default config
echo "" | tee /etc/consul.d/consul.hcl

# find local IP, transform x.y.z.w => x-y-z-w (to avoid dns issues)
PRIVATE_IP=$(hostname -I | awk '{print $2}' | sed "s/\./-/g")  
PRIVATE_IP_DASH=$(echo $PRIVATE_IP | sed "s/\./-/g")                  # sed "s/[original]/[target]/g", "s" means "substitute", "g" means "global, all matching occurrences"

# consul client
tee /etc/consul.d/consul.hcl > /dev/null <<EOF
# consul client config
node_name  = "client-$PRIVATE_IP_DASH"
datacenter = "dc1"
data_dir   = "/opt/consul"

bind_addr   = "{{ GetInterfaceIP \"enp0s8\" }}"
client_addr = "0.0.0.0"

server        = false
# license_path  = "/etc/consul.d/consul.hclic"
raft_protocol = 3

retry_join = [ "192.168.56.21" ]
retry_interval = "30s"
retry_max = 10


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
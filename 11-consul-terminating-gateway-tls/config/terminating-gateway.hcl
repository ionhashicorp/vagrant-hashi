# Link gateway named "external_database_virtual_consul_node" with the "external_database" service.
# When starting the terminating gateway, use service "external_service".
Kind = "terminating-gateway"
Name = "external_database_virtual_consul_node"

Services = [
 {
   Name     = "external_database"
   CAFile   = "/vagrant/certificates/ca.pem"
   CertFile = "/vagrant/certificates/client.pem"
   KeyFile  = "/vagrant/certificates/client-key.pem"
   SNI      = "db-client"
 }
]

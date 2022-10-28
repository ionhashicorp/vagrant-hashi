job "tgw-proxy" {

  datacenters = ["dc1"]

  # This group provides the service that exists outside of the Consul Connect
  # service mesh. It is using host networking and listening to a statically
  # allocated port.
#   group "api" {
#     network {
#       mode = "host"
#       port "port" {
#         static = "9001"
#       }
#     }

#     # This example will enable services in the service mesh to make requests
#     # to this service which is not in the service mesh by making requests
#     # through the terminating gateway.
#     service {
#       name = "count-api"
#       port = "port"
#     }

#     task "api" {
#       driver = "docker"

#       config {
#         image        = "hashicorpdev/counter-api:v3"
#         network_mode = "host"
#       }
#     }
#   }

  group "gateway" {
    network {
      mode = "bridge"
    }

    service {
      name = "api-gateway"

      connect {
        gateway {
          # Consul gateway [envoy] proxy options.
          proxy {
            # The following options are automatically set by Nomad if not explicitly
            # configured with using bridge networking.
            #
            # envoy_gateway_no_default_bind = true
            # envoy_gateway_bind_addresses "default" {
            #   address = "0.0.0.0"
            #   port    = <generated listener port>
            # }
            # Additional options are documented at
            # https://www.nomadproject.io/docs/job-specification/gateway#proxy-parameters
          }

          # Consul Terminating Gateway Configuration Entry.
          terminating {
            # Nomad will automatically manage the Configuration Entry in Consul
            # given the parameters in the terminating block.
            #
            # Additional options are documented at
            # https://www.nomadproject.io/docs/job-specification/gateway#terminating-parameters
            service {
              name = "external_database_virtual_consul_node"
            }
          }
        }
      }
    }
  }

  # The dashboard service is in the service mesh, making use of bridge network
  # mode and connect.sidecar_service. When running, the dashboard should be
  # available from a web browser at localhost:9002.
#   group "dashboard" {
#     network {
#       mode = "bridge"

#       port "http" {
#         static = 9002
#         to     = 9002
#       }
#     }

#     service {
#       name = "count-dashboard"
#       port = "9002"

#       connect {
#         sidecar_service {
#           proxy {
#             upstreams {
#               # By configuring an upstream destination to the linked service of
#               # the terminating gateway, the dashboard is able to make requests
#               # through the gateway to the count-api service.
#               destination_name = "count-api"
#               local_bind_port  = 8080
#             }
#           }
#         }
#       }
#     }

#     task "dashboard" {
#       driver = "docker"

#       env {
#         COUNTING_SERVICE_URL = "http://${NOMAD_UPSTREAM_ADDR_count_api}"
#       }

#       config {
#         image = "hashicorpdev/counter-dashboard:v3"
#       }
#     }
#   }
}

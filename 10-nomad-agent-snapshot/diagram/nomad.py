# https://diagrams.mingrammer.com/docs/nodes/aws
# Reference https://github.com/mingrammer/diagrams/issues/17

from diagrams import Diagram, Cluster, Edge
from diagrams.aws.network import Route53, ELB
from diagrams.onprem.network import Consul, Traefik
from diagrams.onprem.compute import Nomad
from diagrams.onprem.security import Vault

outformat="png"
filename = "nomad"

graph_attr = {
    "layout":"dot",
    "compound":"true",
    "splines":"spline",
    "pencolor" : "blue",
    "penwidth" : "2.0",
    "bgcolor" : "white",
    "fontsize": "35",
    }

with Diagram("nomad 3 servers", filename=filename, direction="TB",outformat=outformat, graph_attr=graph_attr):
    with Cluster("CLOUD vagrant"):
        with Cluster("DATACENTER dc1"):
            with Cluster("SERVERS"):
                with Cluster("BOX consul"):
                    consul_global = Consul("server")
                with Cluster("BOX nomad1"):
                    nomad_global1 = Nomad("server1")
                    consul_global1 = Consul("client1")
                with Cluster("BOX nomad2"):
                    nomad_global2 = Nomad("server2")
                    consul_global2 = Consul("client2")
                with Cluster("BOX nomad3"):
                    nomad_global3 = Nomad("server3")
                    consul_global3 = Consul("client3")
                nomad_global1 - Edge(color="darkgreen") - nomad_global2 - Edge(color="darkgreen") - nomad_global3 - Edge(color="darkgreen") - nomad_global1

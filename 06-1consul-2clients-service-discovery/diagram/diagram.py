# https://diagrams.mingrammer.com/docs/nodes/aws
# Reference https://github.com/mingrammer/diagrams/issues/17

from diagrams import Diagram, Cluster, Edge
from diagrams.aws.network import Route53, ELB
from diagrams.onprem.network import Consul, Traefik
from diagrams.onprem.compute import Nomad
from diagrams.onprem.security import Vault

outformat="png"

graph_attr = {
    "layout":"dot",
    "compound":"true",
    "splines":"spline",
    "pencolor" : "blue",
    "penwidth" : "2.0",
    "bgcolor" : "white",
    "fontsize": "35",
    }

with Diagram("Consul diagram", filename="diagram", direction="TB",outformat=outformat, graph_attr=graph_attr):
    with Cluster("CLOUD vagrant"):
        with Cluster("DATACENTER dc1"):
            with Cluster("SERVERS"):
                with Cluster("BOX consul1"):
                    consul_global1 = Consul("")
            with Cluster("CLIENTS"):
                with Cluster("BOX client1"):
                    consul_client1 = Consul("")
                with Cluster("BOX client2"):
                    consul_client2 = Consul("")
        # LINKS
        # if stop of the line passes cluster (doesn't work) try swap values between ltail and lhead
        consul_global1 - Edge(penwidth = "6", color = "deeppink", ltail = "cluster_SERVERS", lhead="cluster_CLIENTS", minlen="2") - [consul_client1, consul_client2]

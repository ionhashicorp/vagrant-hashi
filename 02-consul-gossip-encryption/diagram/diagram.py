# https://diagrams.mingrammer.com/docs/nodes/aws

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
    "bgcolor": "white",
    "fontsize": "35",
    }

with Diagram("Consul diagram", filename="diagram", direction="TB",outformat=outformat, graph_attr=graph_attr):
    with Cluster("CLOUD vagrant"):
        with Cluster("DATACENTER dc1"):
            with Cluster("SERVERS"):
                consul1_global = Consul("consul1")
            with Cluster("CLIENTS"):
                client1 = Consul("client1")
                client2 = Consul("client2")
                consul1_global - Edge(penwidth = "4", lhead = "cluster_SERVERS", ltail="cluster_CLIENTS", minlen="2") - client1
                consul1_global - Edge(penwidth = "4", lhead = "cluster_SERVERS", ltail="cluster_CLIENTS", minlen="2") - client2
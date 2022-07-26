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

with Diagram("Nomad Consul diagram", filename="diagram", direction="TB",outformat=outformat, graph_attr=graph_attr):
    with Cluster("CLOUD vagrant"):
        with Cluster("DATACENTER dc1"):
            with Cluster("SERVERS"):
                with Cluster("BOX nomad-consul"):
                    nomad_global = Nomad("nomad")
                    consul_global = Consul("consul")
            with Cluster("CLIENTS"):
                with Cluster("BOX client1"):
                    nomad_client1 = Nomad("")
                    consul_client1 = Consul("")
                with Cluster("BOX client2"):
                    nomad_client2 = Nomad("")
                    consul_client2 = Consul("")
                # Nomad links
                nomad_global - Edge(penwidth = "4", color = "green", lhead = "cluster_SERVERS", ltail="cluster_CLIENTS", minlen="2") - nomad_client1
                nomad_global - Edge(penwidth = "4", color = "green", lhead = "cluster_SERVERS", ltail="cluster_CLIENTS", minlen="2") - nomad_client2
                # Consul links
                consul_global - Edge(penwidth = "4", color = "deeppink", lhead = "cluster_SERVERS", ltail="cluster_CLIENTS", minlen="2") - consul_client1
                consul_global - Edge(penwidth = "4", color = "deeppink", lhead = "cluster_SERVERS", ltail="cluster_CLIENTS", minlen="2") - consul_client2
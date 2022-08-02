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

# https://diagrams.mingrammer.com/docs/nodes/aws
# Reference https://github.com/mingrammer/diagrams/issues/17

from diagrams import Diagram, Cluster, Edge
from diagrams.k8s.infra import Master
from diagrams.k8s.infra import Node

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

with Diagram("Consul kubernetes", filename="consul", direction="TB",outformat=outformat, graph_attr=graph_attr):
    with Cluster("vagrant"):
        with Cluster("SERVERS"):
            with Cluster("BOX master1"):
                master1 = Master("192.168.56.51")
        with Cluster("CLIENTS"):
            with Cluster("BOX client1\n192.168.56.101"):
                client1 = Node(height="0.8", width="0.8")
                with Cluster("CONTAINER1"):
                    consul_server0 = Consul("consul-SRV")
                with Cluster("CONTAINER2"):
                    consul_client1 = Consul("client")
            with Cluster("BOX client2\n192.168.56.102"):
                client2 = Node(height="0.8", width="0.8")
                with Cluster("CONTAINER3"):
                    consul_client2 = Consul("client")
        # LINKS
        # if stop of the line passes cluster (doesn't work) try swap values between ltail and lhead
        master1 - Edge(penwidth = "6", color = "blue", ltail = "cluster_SERVERS", lhead="cluster_CLIENTS", minlen="2") - [client1, client2]
        client1 - Edge(lhead = "cluster_CONTAINER1") - consul_server0
        client2 - Edge(minlen="2", lhead = "cluster_CONTAINER3") - consul_client2
        consul_server0 - Edge(penwidth = "6", color = "deeppink", ltail = "cluster_CONTAINER1", lhead="cluster_CONTAINER2", minlen="1") -  consul_client1
        consul_server0 - Edge(penwidth = "6", color = "deeppink", ltail = "cluster_CONTAINER1", lhead="cluster_CONTAINER3", minlen="1") -  consul_client2

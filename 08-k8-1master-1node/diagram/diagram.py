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

with Diagram("Kubernetes", filename="diagram", direction="TB",outformat=outformat, graph_attr=graph_attr):
    with Cluster("vagrant"):
        with Cluster("SERVERS"):
            with Cluster("BOX master1"):
                master1 = Master("192.168.56.51")
        with Cluster("CLIENTS"):
            with Cluster("BOX client1"):
                client1 = Node("192.168.56.101")
        # LINKS
        # if stop of the line passes cluster (doesn't work) try swap values between ltail and lhead
        master1 - Edge(penwidth = "6", color = "blue", ltail = "cluster_SERVERS", lhead="cluster_CLIENTS", minlen="2") - client1

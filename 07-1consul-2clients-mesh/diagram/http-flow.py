# https://diagrams.mingrammer.com/docs/nodes/aws
# Reference https://github.com/mingrammer/diagrams/issues/17

from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import EC2
from diagrams.onprem.client import User
from diagrams.onprem.network import Envoy

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

with Diagram("HTTP flow", filename="http-flow", direction="LR",outformat=outformat, graph_attr=graph_attr):
    with Cluster("CLOUD vagrant"):
        with Cluster("DATACENTER dc1"):
            user = User("user")
            with Cluster("CLIENTS"):
                with Cluster("BOX client1 \t192.168.56.51"):
                    envoy_client1 = Envoy("WEB")
                    worker_client1 = EC2("WEB .51")
                    worker_client1 - Edge(penwidth = "5", color = "darkblue", ltail = "cluster_SERVERS", lhead="cluster_BOX client1", minlen="1", label = "5000") >> envoy_client1

                with Cluster("BOX client2 \t192.168.56.52"):
                    envoy_client2 = Envoy("API")
                    worker_client2 = EC2("API .52")
                    envoy_client2 - Edge(penwidth = "5", color = "darkblue", ltail = "cluster_SERVERS", lhead="cluster_BOX client1", minlen="1", label = "8080") >> worker_client2
                
                
        # LINKS
        # if stop of the line passes cluster (doesn't work) try swap values between ltail and lhead
        user - Edge(penwidth = "5", color = "darkblue", ltail = "cluster_SERVERS", lhead="cluster_BOX client1", minlen="1", label = "9090") >> worker_client1
        envoy_client1 - Edge(penwidth = "5", color = "darkblue", ltail = "cluster_SERVERS", lhead="cluster_BOX client1", minlen="1") >> envoy_client2
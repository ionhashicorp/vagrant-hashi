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

with Diagram("Consul Nomad federation", filename="diagram", direction="TB",outformat=outformat, graph_attr=graph_attr):
    with Cluster("CLOUD vagrant"):
        with Cluster("CONSUL DATACENTER usa-dc1"):
            with Cluster("SERVERS USA"):
                with Cluster("BOX consul-nomad-usa1"):
                    server_nomad_usa1 = Nomad("")
                    server_consul_usa1 = Consul("")
            with Cluster("CLIENTS USA"):
                with Cluster("BOX client-usa1"):
                    client_nomad_usa1 = Nomad("")
                    client_consul_usa1 = Consul("")
        with Cluster("CONSUL DATACENTER emea-dc1"):
            with Cluster("SERVERS EMEA"):
                with Cluster("BOX consul-nomad-emea1"):
                    server_nomad_emea1 = Nomad("")
                    server_consul_emea1 = Consul("")
            with Cluster("CLIENTS EMEA"):
                with Cluster("BOX client-emea1"):
                    client_nomad_emea1 = Nomad("")
                    client_consul_emea1 = Consul("")

        # LINKS
        # if stop of the line passes cluster (doesn't work) try swap values between ltail and lhead
        # nomad_emea1 - Edge(penwidth = "6", color = "darkgreen", ltail = "cluster_SERVERS", lhead="cluster_CLIENTS", minlen="2") - [nomad_client1, nomad_client2]
        # consul_global2 - Edge(penwidth = "6", color = "deeppink", ltail = "cluster_SERVERS", lhead="cluster_CLIENTS", minlen="2") - [consul_client1, consul_client2]
        server_nomad_emea1 - Edge(penwidth = "6", color = "darkgreen", ltail = "cluster_SERVERS EMEA", lhead="cluster_CLIENTS EMEA", minlen="2") -  client_nomad_emea1
        server_nomad_usa1 - Edge(penwidth = "6", color = "darkgreen", ltail = "cluster_SERVERS USA", lhead="cluster_CLIENTS USA", minlen="2") - client_nomad_usa1

        server_consul_emea1 - Edge(penwidth = "6", color = "deeppink", ltail = "cluster_SERVERS EMEA", lhead="cluster_CLIENTS EMEA", minlen="2") -  client_consul_emea1
        server_consul_usa1 - Edge(penwidth = "6", color = "deeppink", ltail = "cluster_SERVERS USA", lhead="cluster_CLIENTS USA", minlen="2") - client_consul_usa1

        # server_consul_emea1 - Edge(penwidth = "6", color = "deeppink", ltail = "cluster_SERVERS EMEA", lhead="cluster_SERVERS USA", minlen="2") - server_consul_usa1
        # server_nomad_emea1 - Edge(penwidth = "6", color = "darkgreen", ltail = "cluster_BOX consul-nomad-emea1", lhead="cluster_SERVERS USA", minlen="1") - server_consul_usa1

        # server_consul_emea1 - server_nomad_usa1
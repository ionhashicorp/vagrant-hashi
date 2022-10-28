from diagrams import Diagram, Cluster, Edge
from diagrams.onprem.network import Consul
from diagrams.onprem.client import User
from diagrams.azure.general import Resource
from diagrams.aws.database import Aurora

filename = "access_consul"

graph_attr = {
    "compound":"true",
    "fontsize": "45",
    }

with Diagram("consul access", filename = filename, graph_attr=graph_attr, direction = "LR"):
    operator_server_1 = User("CONSUL_HTTP_ADDR\nhttp://192.168.56.11:8500")
    operator_client_2 = User("CONSUL_HTTP_ADDR\nhttp:192.168.56.51:8500")
    operator_client_3 = User("CONSUL_HTTP_ADDR\nhttp:192.168.56.52:8500")
    operator_client_4 = User("CONSUL_HTTP_ADDR\nhttp:192.168.56.53:8500")


    with Cluster("VAGRANT"):
        with Cluster("VM   consul1"):
            consul_server_1 = Consul("server\n192.168.56.11")

        with Cluster("VM   client1_web"):
            consul_client_1 = Consul("client\n192.168.56.51")

        with Cluster("VM   client2_api"):
            consul_client_2 = Consul("client\n192.168.56.52")

        with Cluster("VM   client3_tgw"):
            consul_client_3 = Consul("client\n192.168.56.53")

        with Cluster("VM   db\n\n PORT: 5432"):
            db = Aurora("DB\n192.168.56.54")

            operator_server_1 - Edge(penwidth = "3", color = "deeppink", label = ":8500") >> consul_server_1
            operator_client_2 - Edge(penwidth = "3", color = "deeppink", label = ":8500") >> consul_client_1
            operator_client_3 - Edge(penwidth = "3", color = "deeppink", label = ":8500") >> consul_client_2
            operator_client_4 - Edge(penwidth = "3", color = "deeppink", label = ":8500") >> consul_client_3
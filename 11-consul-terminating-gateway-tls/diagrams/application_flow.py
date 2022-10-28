from diagrams import Diagram, Cluster, Edge, Node
from diagrams.onprem.network import Consul
from diagrams.onprem.client import User
from diagrams.onprem.network import Envoy
from diagrams.onprem.monitoring import Prometheus
from diagrams.onprem.monitoring import Grafana

from diagrams.azure.general import Resource
from diagrams.aws.database import Aurora

filename = "application_flow"

graph_attr = {
    "compound":"true",
    "fontsize": "45",
    }

with Diagram("app flow\nterminating gateway", filename = filename, graph_attr=graph_attr, direction = "TB"):
    operator_browser = User("BROWSER\nhttp:localhost:9090")
    with Cluster("VAGRANT"):
        with Cluster("VM consul1\n192.168.56.11"):
            consul_server_1 = Consul("server")

        with Cluster("VM client1_web\n192.168.56.51"):
            web_service = Resource("web-service")
            web_proxy = Envoy("web-proxy")
            consul_client_web = Consul("client")
        
        with Cluster("VM client2_api\n192.168.56.52"):
            server_client_api = Consul("client")
            api_service = Resource("api-service")
            api_proxy = Envoy("api-proxy")
            api_proxy2 = Envoy("api-proxy")

        with Cluster("VM client3_tgw\n192.168.56.53"):
            server_client_api = Consul("client")
            tgw = Envoy("tgw-proxy")

        with Cluster("VM   db"):
            db = Aurora("DB\n192.168.56.54")

            operator_browser - Edge(penwidth = "3", label = ":9090", color = "black") >> web_service
            web_service - Edge(penwidth = "3", label = " :9091", color = "black") >> web_proxy
            web_proxy - Edge(penwidth = "3", label = " :2000", color = "black") >> api_proxy
            api_proxy - Edge(penwidth = "3", label = " :8080", color = "black") >> api_service
            api_service - Edge(penwidth = "3", label = " :9003", color = "black") >> api_proxy2
            api_proxy2 - Edge(penwidth = "3", label = " :2000", color = "black") >> tgw
            tgw - Edge(penwidth = "3", label = " :5432 overTLS", color = "black") >> db

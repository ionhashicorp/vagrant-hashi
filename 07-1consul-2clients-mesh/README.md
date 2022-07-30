# 07-1consul-2clients-mesh
This vagrant setup will create
- 2 services and 2 envoy-proxies:
- 3 VMs:
  - consul1 (server)
  - client1 (web service)
  - client2 (api service)

## Before creating resources
- from main repo change directory into this example
```
cd 07-1consul-2clients-mesh
```

## Diagram
![](./diagram/http-flow.png)
![](./diagram/diagram.png)

## Connect
- APP HTTP access: http://192.168.56.51:9090/ui

- Consul API
  - consul1:
  ```
  export CONSUL_HTTP_ADDR='http://192.168.56.11:8500'
  ```

  - client1:
  ```
  export CONSUL_HTTP_ADDR='http://192.168.56.51:8500'
  ```

  - client2:
  ```
  export CONSUL_HTTP_ADDR='http://192.168.56.52:8500'
  ```

## How to use
- create resources
```
vagrant up
```

- list resources
```
vagrant status
```

- SSH
```
vagrant ssh <VM-NAME>
```

- SSH config for vscode
```
vagrant ssh-config <VM-NAME>
```

- destroy resources
```
vagrant destroy -f
```

## Consul
- verify consul setup
```
consul info
consul members
consul operator raft list-peers
```

## Traffic flow
- 2 services and 2 envoy-proxies:
  - web (client1)
    - listens on TCP-9090
    - makes further requests on localhost TCP-5000
  - envoy-sidecar-proxy-web (client1)
    - listens on TCP-8000 and forwards request to envoy-sidecar-proxy-api
  - envoy-sidecar-proxy-api (client2)
    - listens receives request from envoy-sidecar-proxy-web
    - forwards requests on localhost to port TCP-8080
  - api (client2)
    - listens on TCP-8080
    - envoy-proxy requests sent to api (fake-service binary)
    - service registered in consul
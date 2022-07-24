# 1consul-2clients
Create one consul server and two consul clients.

## Before creating resources
- from main repo change directory into this example
```
cd 01-1consul-2clients
```

## Diagram
![](./diagram/diagram.png)

GUI Consul:
- http://192.168.56.11:8500

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
# consul1, client1, client2
vagrant consul1
```

- SSH config for vscode
```
vagrant ssh-config
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

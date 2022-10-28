#!/usr/bin/env bash

# Totorial reference:
# https://learn.hashicorp.com/tutorials/consul/service-mesh-with-envoy-proxy?in=consul/getting-started

# Consul Envoy compatibility
# https://www.consul.io/docs/connect/proxies/envoy#supported-versions


# install func-e
curl -L https://func-e.io/install.sh | bash -s -- -b /usr/local/bin

# download envoy (see compatibility matrix)
func-e use 1.22.2

cp `func-e which` /usr/local/bin
#!/usr/bin/env bash

FAKE_SERVICE_VERSION=v0.24.2
ARCH=amd64
curl -sSL https://github.com/nicholasjackson/fake-service/releases/download/${FAKE_SERVICE_VERSION}/fake_service_linux_${ARCH}.zip | zcat >> /usr/local/bin/fake-service
chmod a+x /usr/local/bin/fake-service

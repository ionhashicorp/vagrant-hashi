#!/usr/bin/env bash

# internet reachable? before continue
until ping4 -c1 releases.hashicorp.com ; do sleep 1; done

# Github release API: https://docs.github.com/en/rest/releases/releases
# Fake service located at https://github.com/nicholasjackson/fake-service/releases
# Get latest release: https://docs.github.com/en/rest/releases/releases#get-the-latest-release

# If JQ not installed, install JQ
which jq || apt-get install -y -qq jq

# Download URL fake-service
URL_LATEST=$(curl -H "Accept: application/vnd.github+json" -sSL https://api.github.com/repos/nicholasjackson/fake-service/releases/latest | jq -r '.assets[] | select(.name == "fake_service_linux_amd64.zip") | .browser_download_url')

curl -o fake_service.zip -sSL $URL_LATEST


# install unzip
which unzip || apt-get install -y unzip

# extract and remove .zip file
unzip fake_service.zip && rm fake_service.zip
chmod +x fake-service

# move file to bin
mv fake-service /usr/local/bin

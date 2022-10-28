#!/usr/bin/env bash

# If the file does not exist then add hashicorp repository
if [ ! -f "/etc/apt/sources.list.d/hashicorp.list" ]; then
    # add the HashiCorp GPG key
      curl --fail --silent --show-error --location https://apt.releases.hashicorp.com/gpg | \
      gpg --dearmor | \
      dd of=/usr/share/keyrings/hashicorp-archive-keyring.gpg

      # add Hashicorp repository to the apt list
      echo "deb [arch=amd64 signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
      tee -a /etc/apt/sources.list.d/hashicorp.list
fi
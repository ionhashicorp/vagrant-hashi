#!/usr/bin/env bash

tee /etc/systemd/system/db.service > /dev/null <<EOF
[Unit]
Description=DATABASE
After=syslog.target network.target

[Service]
Environment="MESSAGE=DATABASE"
Environment="NAME=DB"
Environment="TLS_CERT_LOCATION=/vagrant/certificates/server.pem"
Environment="TLS_KEY_LOCATION=/vagrant/certificates/server-key.pem"
Environment="LISTEN_ADDR=0.0.0.0:5432"
ExecStart=/usr/local/bin/fake-service
ExecStop=/bin/sleep 5
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl enable db
systemctl start db
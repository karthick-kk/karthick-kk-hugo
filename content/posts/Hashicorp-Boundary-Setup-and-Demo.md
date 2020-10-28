---
title: "Hashicorp Boundary Setup and Demo"
date: 2020-10-28T14:34:08+05:30
draft: true
toc: true
images:
tags:
  - boundary
  - hashicorp
---
---
This article explain how to setup a boundary server to authenticate/connect to an internal VM

---

## Boundary Binary Download

URL: https://www.boundaryproject.io/downloads

## Boundary Server

Boundary server has two components - controller and worker. A simple dev server can be started using `boundary dev`

### Server Spec

VM - Any
Network Interfaces:

	- 1 x NAT Network (10.x.x.x)
	- 1 x Host Only/Bridged Network (192.x.x.x/*)

### Setting up Pre-requisite

#### Install Postgresql

Create `docker-compose.yaml`

```yaml
version: '2'

services:
  postgresql:
    image: 'docker.io/bitnami/postgresql:11-debian-10'
    ports:
      - '5432:5432'
    volumes:
      - 'postgresql_data:/bitnami/postgresql'
    environment:
      - 'ALLOW_EMPTY_PASSWORD=yes'
      - POSTGRESQL_USERNAME=postgres
      - POSTGRESQL_PASSWORD=password123
      - POSTGRESQL_DATABASE=boundary
volumes:
  postgresql_data:
    driver: local

```

Run postgresql docker

`docker-compose up -d`

### Setting up controller and worker on a single node

#### Controller Config

Create config file

> /etc/boundary-controller.hcl

```
# Disable memory lock: https://www.man7.org/linux/man-pages/man2/mlock.2.html
disable_mlock = true

# Controller configuration block
controller {
  # This name attr must be unique across all controller instances if running in HA mode
  name = "demo-controller-1"
  description = "A controller for a demo!"

  # Database URL for postgres. This can be a direct "postgres://"
  # URL, or it can be "file://" to read the contents of a file to
  # supply the url, or "env://" to name an environment variable
  # that contains the URL.
  database {
      url = "postgresql://postgres:password123@localhost:5432/boundary?sslmode=disable"
  }
}

# API listener configuration block
listener "tcp" {
  # Should be the address of the NIC that the controller server will be reached on
  address = "192.168.99.102"
  # The purpose of this listener block
  purpose = "api"

  tls_disable = true

  # Uncomment to enable CORS for the Admin UI. Be sure to set the allowed origin(s)
  # to appropriate values.
  #cors_enabled = true
  #cors_allowed_origins = ["yourcorp.yourdomain.com"]
}

# Data-plane listener configuration block (used for worker coordination)
listener "tcp" {
  # Should be the IP of the NIC that the worker will connect on
  address = "192.168.99.102"
  # The purpose of this listener
  purpose = "cluster"

  tls_disable = true
}

# Root KMS configuration block: this is the root key for Boundary
# Use a production KMS such as AWS KMS in production installs
kms "aead" {
  purpose = "root"
  aead_type = "aes-gcm"
  key = "sP1fnF5Xz85RrXyELHFeZg9Ad2qt4Z4bgNHVGtD6ung="
  key_id = "global_root"
}

# Worker authorization KMS
# Use a production KMS such as AWS KMS for production installs
# This key is the same key used in the worker configuration
kms "aead" {
  purpose = "worker-auth"
  aead_type = "aes-gcm"
  key = "8fZBjCUfN0TzjEGLQldGY4+iE9AkOvCfjh7+p0GtRBQ="
  key_id = "global_worker-auth"
}

# Recovery KMS block: configures the recovery key for Boundary
# Use a production KMS such as AWS KMS for production installs
kms "aead" {
  purpose = "recovery"
  aead_type = "aes-gcm"
  key = "8fZBjCUfN0TzjEGLQldGY4+iE9AkOvCfjh7+p0GtRBQ="
  key_id = "global_recovery"
}
```

#### Worker Config

Create config file

> /etc/boundary-worker.hcl

```
listener "tcp" {
    purpose = "proxy"
    address = "192.168.99.102"
    tls_disable = true
}

worker {
  # Name attr must be unique across workers
  name = "demo-worker-1"
  description = "A default worker created demonstration"

  # Workers must be able to reach controllers on :9202
  controllers = [
    "192.168.99.102"
  ]

  public_addr = "192.168.99.102"
}

# must be same key as used on controller config
kms "aead" {
    purpose = "worker-auth"
    aead_type = "aes-gcm"
    key = "8fZBjCUfN0TzjEGLQldGY4+iE9AkOvCfjh7+p0GtRBQ="
    key_id = "global_worker-auth"
}
```


#### Setting up Controller and Worker Service

Create install script

```shell
#!/bin/bash
# Installs the boundary as a service for systemd on linux
# Usage: ./install.sh <worker|controller>

TYPE=$1
NAME=boundary

sudo cat << EOF > /etc/systemd/system/${NAME}-${TYPE}.service
[Unit]
Description=${NAME} ${TYPE}

[Service]
ExecStart=/usr/local/bin/${NAME} server -config /etc/${NAME}-${TYPE}.hcl
User=boundary
Group=boundary
LimitMEMLOCK=infinity
Capabilities=CAP_IPC_LOCK+ep
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK

[Install]
WantedBy=multi-user.target
EOF

# Add the boundary system user and group to ensure we have a no-login
# user capable of owning and running Boundary
sudo adduser --system --group boundary || true
sudo chown boundary:boundary /etc/${NAME}-${TYPE}.hcl
sudo chown boundary:boundary /usr/local/bin/boundary

# Make sure to initialize the DB before starting the service. This will result in
# a database already initizalized warning if another controller or worker has done this
# already, making it a lazy, best effort initialization
if [ "${TYPE}" = "controller" ]; then
  sudo /usr/local/bin/boundary database init -config /etc/${NAME}-${TYPE}.hcl || true
fi

sudo chmod 664 /etc/systemd/system/${NAME}-${TYPE}.service
sudo systemctl daemon-reload
sudo systemctl enable ${NAME}-${TYPE}
sudo systemctl start ${NAME}-${TYPE}
```

Run script to setup controller and worker

```
sudo ./install.sh controller
sudo ./install.sh worker
```

When the controller is installed, initial auth information is created.

```
Initial auth information:
  Auth Method ID:     ampw_8KHJD8hQRJ
  Login Name:         admin
  Password:           ycgHbdayxhYoZG4HaMaj
```



> Note: Preserve login information for initial UI login - http://192.168.99.102:9200



## Connecting to VM via Boundary Server

Authenticate server

```shell
BOUNDARY_ADDR=http://192.168.99.102:9200 boundary authenticate password -auth-method-id=ampw_8KHJD8hQRJ -login-name=admin -password=ycgHbdayxhYoZG4HaMaj
```

Connect SSH

```shell
BOUNDARY_ADDR=http://192.168.99.102:9200 boundary connect ssh -target-id ttcp_yj50ER3Uq3 -token at_Zh5SfzpyYR_s1bWQSM96NgAY9UAy1W235eL3fiaui4QNBkhEkSnYy7ReY24ME2bYK3FtZGZWfX3C7NGPbPABNcgGusvRjQ1EFwc2AS7v1rq6Xxjv1fYnmwDbrLmV7UHdkP5y9ZUxFnN6BAtwRnTH82g2Q -- -l osboxes
```

Users & Access

```shell
boundary roles update -grant-scope-id=p_tkwQtiybAR -id=r_MJpRFZlFsO -token at_i0VuJvNsla_s1Dy8URtX8J23CUmcZt6v3SN3xdPYTFLFxztgF6bGB8JqPWZwVRGEkrpTqPa9Bc5xVRNY4v2o63b8WAfa1xTwLqufUMfXUz17JCpDjsi
BOUNDARY_ADDR=http://192.168.50.10:9200 boundary roles list -scope-id p_tkwQtiybAR -token at_i0VuJvNsla_s1Dy8URtX8J23CUmcZt6v3SN3xdPYTFLFxztgF6bGB8JqPWZwVRGEkrpTqPa9Bc5xVRNY4v2o63b8WAfa1xTwLqufUMfXUz17JCpDjsi
BOUNDARY_ADDR=http://192.168.50.10:9200 boundary connect ssh -target-id ttcp_jRA1wIGwVS -token at_i0VuJvNsla_s1Dy8URtX8J23CUmcZt6v3SN3xdPYTFLFxztgF6bGB8JqPWZwVRGEkrpTqPa9Bc5xVRNY4v2o63b8WAfa1xTwLqufUMfXUz17JCpDjsi -- -l vagrant
```

---
title: "Awx Upgrade Docker"
date: 2021-02-12T10:15:03+05:30
draft: true
toc: true
images:
tags:
  - Upgrade
---
---
This article explains upgrade of awx services running on docker.

---

## Stop AWX Services

In some case, tag `latest` needs to be replaced with current version running on the system.

```sh
docker stop awx_task
docker rm awx_task
docker rmi ansible/awx_task:latest

docker stop awx_web
docker rm awx_web
docker rmi ansible/awx_web:latest
```



## Backup Inventory File

```sh
cp ~/awx/installer/inventory ~/inventory
```



## Refresh AWX Code

```sh
cd ~/awx/installer
git stash
git pull
cd installer
```



## Run Upgrade

```
export GPG_TTY=$(tty)
cd installer
# Review inventory (Update passwords and vars from backed up inventory file)
ansible-playbook -i inventory install.yml
```

>If prompted for passphrase input, provide docker hub login password



## Start AWX Services

```sh
cd ~/.awx/awxcompose
docker-compose up -d
```

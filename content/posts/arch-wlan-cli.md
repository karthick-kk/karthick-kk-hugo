---
title: "Wireless LAN CLI Configuration under Arch Linux"
date: 2021-04-09T09:19:16+05:30
draft: true
toc: false
images:
tags:
  - Arch
  - Cli
---

Steps to configure a wireless adapter to connect to nearby access point by shell commands


#### Runbook
```sh
$ sudo systemctl start iwd
$ sudo iwctl --passphrase <secret> station wlan0 connect <accesspoint>
$ sudo systemctl start dhcpcd@wlan0
```

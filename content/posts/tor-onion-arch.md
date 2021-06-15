---
title: "Tor toggle for Firefox on Arch"
date: 2021-05-10T20:11:40+05:30
draft: true
toc: true
images:
tags:
  - arch
  - tor
---

---

This article explains how to configure tor/onion network for firefox browser on arch linux. Tor browser(https://www.torproject.org) still remains the recommended or easiest means of using tor network for browsing with privacy.

---

## Install tor and privoxy

```sh
$ yay -S tor
$ yay -S privoxy
```

## Starting tor

```sh
$ sudo systemctl enable tor
$ sudo systemctl start tor
```

## Starting privoxy

Tor client runs on port 9050. Privoxy should be configured to use this socks port to forward all http/https traffic. Add the line at the end of the file `/etc/privoxy/config`

```sh
forward-socks5 / localhost:9050 .
```

## Configure network proxy setting

Open Firefox->Preferences and change the network settings to use the new proxy configuration

```markdown
HTTP Proxy -> localhost Port 8118
SOCKS Host -> localhost Port 9050
```

![image-20210510211801331](https://raw.githubusercontent.com/corestackdev/images/main/image-20210510211801331.png)

## Install proxy toggle addon

Install the proxy toggle addon from https://addons.mozilla.org/en-US/firefox/addon/proxy-toggle-button to enable/disable `tor proxy`

![image-20210510212741684](https://raw.githubusercontent.com/corestackdev/images/main/image-20210510212741684.png)


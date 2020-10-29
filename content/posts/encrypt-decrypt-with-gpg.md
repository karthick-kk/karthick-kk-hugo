---
title: "Encrypt Decrypt With Gpg"
date: 2020-10-29T23:21:06+05:30
draft: false
toc: true
images:
tags:
  - untagged
---

---
This article explains how to encrypt and decrypt files on unix with GNU Gpg
---

## Setup GNU gpg

### Generate Keys
```shell
gpg --full-generate-key
```
* no passphrase

### Encrypting a file
```shell
gpg -e -r "karthick" .wekan.json
```

### Decrypting the file
```shell
gpg -o /var/tmp/.wekan.json -d .wekan.json.gpg
```

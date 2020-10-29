---
title: "Encrypt Decrypt With Gpg"
date: 2020-10-30T00:00:09+05:30
draft: false
toc: true
images:
tags:
  - security
---

---
This article explains encryption and decryption of files using GNU gpg
---

## Setup GNU gpg

### Generate Keys
```shell
gpg --full-generate-key
```
* passphrase is optional

### Encrypting a file
```shell
gpg -e -r "karthickk" .wekan.json
```
> This creates a file with an extension .gpg

### Decrypting a file
```shell
gpg -o .wekan.json -d .wekan.json.gpg
```

---
title: "Clean Chroot Builds on Arch Linux"
date: 2020-11-10T16:23:49+05:30
draft: true
toc: false
images:
tags:
  - install
---
---
A clean chroot build is preferred when there are package dependencies during aur package installation.
This article should allow us to perform one such clean chroot build using the guided aur package called [clean chroot manager(ccm)](https://github.com/graysky2/clean-chroot-manager).

---

### Install CCM

```shell
yay -S clean-chroot-manager
```

### Setup base config for chroot

- Run the `sudo ccm64 c` command to generate a default **clean-chroot-manager.conf**
- Create a chroot path running `mkdir ~/chroot`

- Edit this file and update the `CHROOTPATH64="/home/karthick-k/chroot"` to a valid path

```shell
nano ~/.config/clean-chroot-manager.conf
```

### Build a new aur package from chroot

- We could use any package source from aur. I'm using [teams for linux](https://aur.archlinux.org/packages/teams-for-linux/) in this case

```shell
git clone https://aur.archlinux.org/teams-for-linux.git
```

- Change directory to **PKGBUILD** folder of the aur package

```shell
$ cd teams-for-linux; ls -l                       
total 164
-rw-r--r-- 1 karthick-k karthick-k    459 Nov 10 14:01 index.patch
-rw-r--r-- 1 karthick-k karthick-k   1833 Nov 10 14:01 PKGBUILD
-rw-r--r-- 1 karthick-k karthick-k    279 Nov 10 14:01 teams-for-linux.desktop
```

- Build the package

```shell
sudo ccm64 s
```

- List the package that are built

```shell
$ sudo ccm64 l
==> Listing out packages in buildroot repo...
total 63M
-rw-r--r-- 1 root root 63M Nov 10 14:34 teams-for-linux-1.0.5-1-x86_64.pkg.tar.zst
```

### Install the package

```shell
sudo pacman -U teams-for-linux-1.0.5-1-x86_64.pkg.tar.zst
```

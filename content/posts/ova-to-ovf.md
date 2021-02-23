---
title: "Converting VirtualBox OVA to VMware Compatible OVF"
date: 2021-02-23T14:29:17+05:30
draft: true
toc: true
images:
tags:
  - Vmware
  - Virtualization
  - Migration
---
---
This guide use the possible freeware tools to perform the conversion.

---

## Conversion Need?

Virtualbox does not generate Vmware Cloud/Vmware ESXi compatible OVA/OVF files

## Tools Required

- Vmware Player

- ovftool

  ** VMware account needed to download (free to signup) **

## Conversion Process

Step 1:

Export the VM as OVA from virtualbox

Step 2:

Import the OVA on to installed VMware player. When prompted to retry/cancel, proceed with retry importing, ignoring the warning messages any.

Step 3:

Run the ovftool to generate the .ovf,.mf and .vmdk files of the imported VM

```sh
$ ovftool ~/vmware/OL8/OL8.vmx ~/ol8-vmware-exported.ovf                           
Opening VMX source: /home/karthick-k/vmware/OL8/OL8.vmx
Opening OVF target: /home/karthick-k/ol8-vmware-exported.ovf
Writing OVF package: /home/karthick-k/ol8-vmware-exported.ovf
Transfer Completed
Completed successfully
```

Step 4:

- Edit .mf file and remove SHA256 value of .ovf file in first line.

- Edit .ovf file and change line with string `VirtualSystemType` with updated vmx-xx version

  `<vssd:VirtualSystemType>vmx-14</vssd:VirtualSystemType>`

The files are now ready to be imported with Vmware Cloud or ESXi cluster.

Reference: https://zhengwu.org/convert-virtual-machine-of-virtualbox-to-esxi/

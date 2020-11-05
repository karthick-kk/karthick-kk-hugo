---
title: "Opengl Compositor Crash Fix Restart"
date: 2020-11-05T14:17:26+05:30
draft: false
toc: true
images:
tags:
  - kde
  - workaround
  - fix
---
---
A workaround to get rid of x11/compositor crash in KDE 5.x for Intel HD GPUs

---

## OpenGL-Compositor crash fix on wakeup/unlock event

This is a simple workaround to recover from the kde compositor crashes that renders the screen with black artifacts with non-responding UI.

The idea is to keep a script running in the background which capture the dbus event of lock/unlock screen to restart kwin window manager.

### Restart script

> restart_kwin.sh

```shell
dbus-monitor --session "type='signal',interface='org.freedesktop.ScreenSaver'" |
  while read x; do
    case "$x" in
      *"boolean true"*) pkill kwin_x11;;
      *"boolean false"*) kwin_x11 --replace;;  
    esac
  done
```

### Autostart task



![image-20201105095954085](https://raw.githubusercontent.com/corestackdev/images/main/image-20201105095954085.png)



## How it works

The autostart script monitors for lock/unlock event continuously in the background. On every unlock event, it triggers a kwin window manager restart using the command `kwin_x11 --replace`

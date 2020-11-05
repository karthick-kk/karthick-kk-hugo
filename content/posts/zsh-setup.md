---
title: "Zsh Setup"
date: 2020-11-05T18:32:55+05:30
draft: true
toc: true
images:
tags:
  - zsh
---
---
This guide is to provide some quick steps to setup zsh,oh-my-zsh framework with essential plugins and powerline10k theme

---
## Change default shell to zsh

```shell
sudo usermod -s /usr/bin/zsh $USER
```

## Setup oh-my-zsh framework

An excellent framework with extensible plugins and themes to manage zsh configurations.

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Install essential plugins

```shell
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

### Enable installed plugins

Update `~/.zshrc` file to enable the installed **plugins**

```i\
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
```

## Installing Powerlevel10K Theme

Although zsh comes with many pre-installed themes, this external community supported theme standsout.

### Install required fonts

```shell
yain ttf-dejavu ttf-meslo-nerd-font-powerlevel10k
```

### Install the theme

```shell
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

When the installation is complete, a wizard will guide us through the rest of configuration and tweaks for a powerup shell

The wizard can anytime be re-run with `p10k configure` command

---
publish: true
id: 1739644546-downgrade-arch-linux-installed-package
aliases:
  - Downgrade Arch Linux Installed Package
tags:
  - linux
title: Downgrade Arch Linux Installed Package
created: 2025-02-16 02:36
modified: 2025-11-17 01:38
---

# Downgrade Arch Linux Installed Package

## Use Downgrade

### Install

```bash
yay -S downgrade
```

### Usage

Ex, downgrade `mesa` to `24.2.7`

```bash
downgrade mesa
```

> It will popup an fzf window, select the version you want to downgrade to, then press `Enter` to confirm.
>
> Before finish, there is also a prompt to confirm that are you want to include that to the IgnorePkg lists? On my side I will do `y` for yes.

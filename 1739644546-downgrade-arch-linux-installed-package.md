---
id: 1739644546-downgrade-arch-linux-installed-package
aliases:
  - Downgrade Arch Linux Installed Package
tags:
  - linux
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

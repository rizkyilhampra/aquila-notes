---
id: 1781315596-setup-arch-linux-in-wsl
aliases:
  - Setup Arch Linux in WSL
tags: []
publish: false
created:
modified:
---
# Setup Arch Linux in WSL

```bash
wsl --update
wsl --install archlinux
```

Update the root password
```bash
passwd
```

Update deps and install necessary thingy
```bash
pacman -Syyu
pacman -S base-devel git nano vim wget curl unzip zip sudo
```

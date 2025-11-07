---
id: 1762512935-steps-i-do-when-extending-or-resizing-a-vm-disk-in-proxmox
aliases:
  - Steps I do when extending or resizing a VM disk in Proxmox
tags:
  - proxmox
publish: true
created: 2025-11-07 18:55
modified: 2025-11-07 19:05
title: Steps I do when extending or resizing a VM disk in Proxmox
---

# Steps I do when extending or resizing a VM disk in Proxmox

## Preq
Download the [GParted ISO](https://sourceforge.net/projects/gparted/).
## Steps

Go to storage on main node or node you are working on. In my case it's `local (server)`.
> `server` is the node.

![[attachment/20251107-1.png]]

Go to **ISO Images** tab. The UI would looks like this. 
> Cause i have some ISO had uploaded before, then that's way you are see there are some ones.

![[attachment/20251107-2.png]]

Click an button **Upload** then select the ISO file, then click the **Upload**  button at bottom, then wait until uploading process it's finish.

![[attachment/20251107-3.png]]

Select the VM you are working on. In my case `103 (debian)`. Go to **Hardware** tab.
![[attachment/20251107-5.png]]

Find **CD/DVD Drive** then click the **Edit** button. You are see the popup occur. Select the ISO file (gparted) then click **OK**.

![[attachment/20251107-6.png]]

Then go to **Options** tab.

![[attachment/20251107-4.png]]

Double click **Boot Order** then reorder  to make the **CD/DVD Drive** it's on top, then click **OK**.

![[attachment/20251107-7.png]]

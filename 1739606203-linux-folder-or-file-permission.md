---
id: 1739606203-linux-folder-or-file-permission
aliases: []
tags: []
---

> [!NOTE]
> ***Prerequisites:*** 
> Append the user of web server process to the sudoer user group. In example, the web process user is `daemon` then the sudoer user and group is `it-rspi`. 

```bash
sudo chown -R $USER:$USER path/to/folder
```

> This will change the owner of the folder to your user.

```bash
sudo chmod -R 2775 path/to/folder
```

> This will change the permission of the folder to `drwxrwsr-x`.

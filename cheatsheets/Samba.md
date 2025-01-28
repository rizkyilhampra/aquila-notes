## Configuration file
```bash
sudoedit /etc/samba/smb.conf
```
## Reload
```bash
sudo systemctl reload smb.service
```
## Start
```bash
sudo systemctl start smb.service
```

> Cause the laptop it's connect through private network on working. So it can't to be enabled through systemd by default. So it's need to start manually
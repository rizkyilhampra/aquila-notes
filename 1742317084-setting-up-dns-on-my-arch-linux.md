---
id: 1742317101-setting-up-dns-on-my-arch-linux
alias: Setting Up DNS on My Arch Linux
tags: []
---
# Setting Up DNS on My Arch Linux
## Why
I was tried [Glance](https://github.com/glanceapp/glance) , one of the widget is [Reddit](https://www.reddit.com) which do call of the reserved IP's from reddit for getting list of top of content of subreddit. I notice my host unable to call those IP's, so that's cause I live in the country that one of the ISP blocked access to reddit. Commonly I still able connect to reddit when using browser which do through use Cloudflare as an DNS. But now I need my network host do still able connect to reddit. So this is my writing how I was able to connect to reddit but not only those thing, but I able to change and use other DNS provider.

## Steps
### Enable and start `systemd-resolved`

> [!NOTE]
> In my case I didn't use `systemd-resolved` so do I now enable and start those service 

```bash
sudo systemctl enable systemd-resolved.service && \
sudo systemctl start systemd-resolved.service
```
### Symlink the `/etc/resolv.conf`

```bash
ln -sf ../run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```

### Configure the `/etc/systemd/resolved.conf`

```bash
sudoedit /etc/systemd/resolved.conf
```

Here is my following configuration I used

```conf
[Resolve]
DNS=1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com 2606:4700:4700::1111#cloudflare-dns.com 2606:4700:4700::1001#cloudflare-dns.com
FallbackDNS=1.1.1.1#cloudflare-dns.com 9.9.9.9#dns.quad9.net 8.8.8.8#dns.google 2606:4700:4700::1111#cloudflare-dns.com 2620:fe::9#dns.quad9.net 2001:4860:4860::8888#dns.google
DNSSEC=no
DNSOverTLS=yes
```

After change, do restart of `systemd-resolved`

```bash
sudo systemctl restart systemd-resolved.service
```

### Check If it's working
They are several ways to check, but in my case I do is
```bash
resolvctl
```
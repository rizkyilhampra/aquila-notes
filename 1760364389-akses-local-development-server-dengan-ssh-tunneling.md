---
id: 1760364487-akses-local-development-server-dengan-ssh-tunneling
alias: Akses local development server dengan ssh tunneling
tags: []
---
# Akses local development server dengan ssh tunneling

Tulisan ini didasari kebutuhan saya untuk mengakses PC kantor yang disana terdapat *local development server* yang sedang berjalan. Sebelum mengetahui langkah ini, saya biasanya melakukan *tunnneling* menggungkan `cloudflared`. Itu mengharuskan saya untuk membuat domain baru dan *mapping* *port* yang ingin digunakan agar saya dapat mengakses *web* atau aplikasi tersebut secara jarak jauh (diluar dari *local area network*). Setelah terbesit suatu pertanyaan, mungkinkah kita *tunnneling* dengan hanya bermodal SSH saja yang telah terkoneksi, sehingga kita hanya buka atau cukup *mapping* *port* 22 saja? Ternyata bisa. 

```bash
ssh -fN -o ExitOnForwardFailure=yes -L 3000:localhost:3000 user@192.168.1.68
```

> *  asdf
> - f

atau di *foreground*

```bash
ssh -L 3000:localhost:3000 user@192.168.1.68
```

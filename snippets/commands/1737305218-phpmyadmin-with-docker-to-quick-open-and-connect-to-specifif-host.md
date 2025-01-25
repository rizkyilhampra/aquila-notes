---
id: 1737305218-phpmyadmin-with-docker-to-quick-open-and-connect-to-specific-host
aliases:
  - phpMyAdmin with Docker to quick open and connect to specific host
tags: []
---

# phpMyAdmin with Docker to quick open and connect to specific host

```bash
docker run -d --name phpmyadmin -e PMA_ARBITRARY=1 -p 8080:80 phpmyadmin:latest
```

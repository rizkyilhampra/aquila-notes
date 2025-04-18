---
id: standalone database container
aliases: []
tags: []
---

Creates a reliable, networked MariaDB container that runs on a custom Docker network. It ensures the database remains operational with data persistence, automatic restarts, and regular health checks to monitor its status.

```bash
docker network create mlite-sik9-network
docker run -d \
  --name mlite-sik9-database \
  --network mlite-sik9-network \
  --restart unless-stopped \
  -v /mnt/Windows/mlite_rspi_data/:/var/lib/mysql \
  -e MYSQL_DATABASE=sik9 \
  -p 3306:3306 \
  --health-cmd="mysqladmin ping -h 127.0.0.1" \
  --health-interval=30s \
  --health-retries=3 \
  --health-timeout=10s \
  mariadb:10.1.25
```

---
id: 1747061684-create-detached-standalone-database-mysql-container
aliases:
  - create detached standalone database (mysql) container
tags:
  - mysql
  - docker
---
# Create detached standalone database (mysql) container

Creates a reliable, networked MariaDB container that runs on a custom Docker network. It ensures the database remains operational with data persistence, automatic restarts, and regular health checks to monitor its status.

## Option 1
> With spesified path for mounting and set default database

```bash
docker network create mlite-sik9-network
docker run -d \
  --name mlite-sik9-database \
  --network mlite-sik9-network \
  --restart unless-stopped \
  -v /mnt/Windows/mlite_rspi_data/:/var/lib/mysql \
  -e MYSQL_DATABASE=sik9 \
  -e MYSQL_ALLOW_EMPTY_PASSWORD=true \
  -p 3306:3306 \
  --health-cmd="mysqladmin ping -h 127.0.0.1" \
  --health-interval=30s \
  --health-retries=3 \
  --health-timeout=10s \
  mariadb:10.1.25
```

## Option 2
> With named volume

```bash
docker run -d \
  --name mariadb-rspi-database \
  --network mariadb-rspi-database-network \
  --restart unless-stopped \
  -v mariadb-rspi-database-volume:/var/lib/mysql \
  -e MYSQL_ALLOW_EMPTY_PASSWORD=true \
  -p 3306:3306 \
  --health-cmd="mysqladmin ping -h 127.0.0.1" \
  --health-interval=30s \
  --health-retries=3 \
  --health-timeout=10s \
  mariadb:10.1.25
```
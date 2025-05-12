---
id: 1736003812-backup-a-large-mysql-mariadb-database-to-a-gzip-file
aliases:
  - Backup a large MySQL MariaDB database to a GZIP file
tags:
  - docker
  - mysql
---

# Backup a large MySQL MariaDB database to a GZIP file

It will create a standalone container from `mariadb:10.1.25` image, backup a database from a remote include `trigger` and `procedure`, pipe to `pv`, use `gzip` for compression, and send `stdout` to some path.

### Why?

- You don't have to installed MariaDB/MySQL on your local machine.
- You don't have to be worry about compatibility issue between the remote and local database version if you have already installed. You can specify MySQL/MariaDB image you want to use.

```bash
docker run --rm \
  -e MYSQL_ALLOW_EMPTY_PASSWORD=1 \
  --network host \
  mariadb:10.1.25 \
  mysqldump \
    -u root \
    -h 192.168.1.4 \
    --single-transaction \
    --routines \
    --triggers \
    --events \
    --max-allowed-packet=1G \
    --quick \
    sik9 \
  | pv --timer --bytes --rate \
  | gzip \
  > /mnt/Windows/sik9.sql.gz
```

> If you want to backup a structure database only, you can add `--no-data` flag

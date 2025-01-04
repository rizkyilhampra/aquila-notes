---
id: 1736003877-restore-a-large-mysql-mariadb-database-from-a-gzip-file
aliases:
  - Restore a large MySQL MariaDB database from a GZIP file
tags: []
---

# Restore a large MySQL MariaDB database from a GZIP file

If you have containerized MySQL/MariaDB database, you can restore a database from a `gzip` file, by piping to specific database container.

```bash
gunzip < /mnt/Windows/sik9.sql.gz \
    | pv --timer --bytes --rate \
    | docker exec -i mlite_rspi-db-1 \
        mysql -u root sik9
```

> The `mlite_rspi-db-1` is the database container name that you want to restore the database.

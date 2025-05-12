---
id: 1736003618-create-a-single-container-to-estimate-the-database-size
aliases:
  - Create a single container to estimate the database size
tags:
  - docker
  - mysql
---

# Create a single container to estimate the database size

```bash
docker run --rm \
    -e MYSQL_ALLOW_EMPTY_PASSWORD=1 \
    mariadb:10.1.25 \
    mysql -u root -h 192.168.1.4 -sN -e 'SELECT ROUND(SUM(data_length + index_length) * 1.1) FROM information_schema.TABLES WHERE table_schema = "sik9";'
```

> You can change the host `192.168.1.4` and database name `sik9` following your fit
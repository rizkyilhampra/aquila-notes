---
id: 1735537505-docker-example-commands
aliases:
  - Docker Example Commands
tags: []
---

# Docker Example Commands

## Backup

Created container from `mariadb:10.1.25` to backup a database, pipe to `pv`, use `gzip` for compression, and stdout .

```bash
docker exec -it vigilant_easley \                                             
      mysqldump \                                                                 
        -u root \                                                                 
        -h 192.168.1.4 \                                                          
        --single-transaction \                                                    
        --routines \                                                              
        --triggers \                                                              
        --events \                                                                
        --max-allowed-packet=1G \                                                 
        sik9 \                                                                    
      | pv \                                                                      
      | gzip \                                                                    
      > /mnt/Windows/sik9.sql.gz
```

## Restore

Restore a database from a `gzip` file, pipe to `pv`, and use `gunzip` to decompress.

```bash
gunzip < /mnt/Windows/sik9.sql.gz \
    | pv \
    | docker exec -i mlite_rspi-db-1 \ 
        mysql -u root sik9
```

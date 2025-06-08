---
id: 1749374699-execute-sql-migration-script-inside-mysql-docker-container
alias: Execute SQL Migration Script Inside MySQL Docker Container
tags: []
---
# Execute SQL Migration Script Inside MySQL Docker Container

```bash
docker exec -i named-mysql-database-container mysql -A -vv database_name < path/file.sql
```
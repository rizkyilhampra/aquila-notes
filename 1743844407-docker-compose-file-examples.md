---
id: 1743844424-docker-compose-file-examples
aliases:
  - Docker compose file examples
tags:
  - docker
---
# Docker compose file examples
## Version 1

```yml
services:
  web:
    build: .
    ports:
      - "80:80"
    volumes:
      - .:/var/www/html
    depends_on:
      - db
  db:
    image: mariadb:10.1.25
    environment:
      MYSQL_DATABASE: sik9
      MYSQL_USER: root
      MYSQL_ALLOW_EMPTY_PASSWORD: '1'
      MYSQL_ALLOW_EMPTY_ROOT_PASSWORD: '1'
    volumes:
      - mysql_data:/var/lib/mysql
    ports:
      - "3307:3306"
    networks:
      - default
  phpmyadmin:
    image: phpmyadmin:latest
    ports:
      - "8181:80"
    environment:
      PMA_HOST: db
    depends_on:
      - db
volumes:
  mysql_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /mnt/Windows/mlite_rspi_data/
```

## Version 2

```yml
services:
  app:
    build:
      context: .
      args:
        UID: ${UID:-1000}
        GID: ${GID:-1000}
    ports:
      - '${APP_PORT:-80}:80'
    volumes:
      - ./:/var/www/html
    environment:
      - APACHE_RUN_USER=www-data
      - APACHE_RUN_GROUP=www-data
    depends_on:
      database:
        condition: service_healthy
    networks:
      - mlite-sik9-network
  database:
    image: mariadb:10.1.25
    environment:
      MYSQL_DATABASE: sik9
      MYSQL_USER: root
      MYSQL_PASSWORD: ${DB_PASSWORD:-}
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD:-}
      MYSQL_ALLOW_EMPTY_PASSWORD: '1'
      MYSQL_ALLOW_EMPTY_ROOT_PASSWORD: '1'
    volumes:
      - mysql_data:/var/lib/mysql
    ports:
      - "${DB_PORT:-3306}:3306"
    healthcheck:
      test: mysqladmin ping -h 127.0.0.1 -u root --password=$${MYSQL_ROOT_PASSWORD}
      interval: 5s
      timeout: 5s
      retries: 5
    networks:
      - app-network
  phpmyadmin:
    image: phpmyadmin:5
    ports:
      - "${PMA_PORT:-8080}:80"
    environment:
      PMA_HOST: mlite-sik9-database
    depends_on:
      - database
    networks:
      - mlite-sik9-network
volumes:
  mysql_data:
networks:
  app-network:
    driver: bridge
    name: mlite-origin-app-network
  mlite-sik9-network:
    external: true
```

## Key of Differences

### Configuration Flexibility
Version of 2 heavily uses environment variables (`${VAR:-default}`) for ports (`APP_PORT`, `DB_PORT`, `PMA_PORT`) and database credentials (`DB_PASSWORD`, `DB_ROOT_PASSWORD`). This allows configuration without editing the `docker-compose.yml` file, making it easier to manage across different environments (dev, staging, prod) or by different users.
### Build Arguments
The app service in version of 2 uses `build.args` (`UID`, `GID`). This is often used to build the container image so that file permissions align with the host user, avoiding permission issues with mounted volumes.
### Robust Dependencies
Version of 2 uses condition: `service_healthy` for the app's dependency on the database. This is much better than a simple `depends_on`, as it waits until the database doesn't just start but actually passes its health check, ensuring it's ready to accept connections before the app tries to connect.
### Healthchecks
Version of 2 explicitly defines a healthcheck for the database. This allows Docker (and other services like `app`) to know the actual status of the database service.
### Security
Version of 2 encourages using passwords for the database via environment variables, which is more secure than the hardcoded allowance of empty passwords in File 1 (though version of 2 still includes the `ALLOW_EMPTY`... flags, which might be redundant or intended for a specific setup workflow).
### Volume Management (`mysql_data`)
Version of 1 forces the `mysql_data` volume to be a specific host directory (`/mnt/Windows/mlite_rspi_data/`) using `driver_opts`. This is non-standard for named volumes, platform-dependent, and less portable. It behaves like a direct bind mount but is declared under volumes.
Version of 2 uses a standard Docker-managed named volume. Docker handles where the data is stored on the host, making it much more portable and the standard way to persist data with Docker.

### Networking
Version of 1 relies on the default bridge network created automatically by Compose.
Version of 2 defines custom bridge networks (`app-network`) and uses an external network (`mlite-sik9-network`). This provides better isolation, allows for more complex network topologies, and enables communication between different Docker Compose projects/stacks sharing the external network. Note: The configuration seems slightly complex: `app` and `phpmyadmin` are on `mlite-sik9-network`, while database is on `app-network`. For `phpmyadmin` to connect to database via `mlite-sik9-database` and for `app` to connect, the database service might need to be attached to both networks or have a network alias configured correctly on the shared network. The current setup might imply app talks to database over `mlite-sik9-network` (if database is also added there implicitly or explicitly elsewhere) and maybe internal services use `app-network`.
### Image Versioning 
Version of 2 pins `phpmyadmin` to a major version (`phpmyadmin:5`) instead of latest. This is generally better practice for stability, as latest can introduce breaking changes unexpectedly.
### Service Naming
Minor renaming (`web`->`app`, `db`->`database`) makes the service roles slightly clearer.
### PHPMyAdmin Host 
Version 1 uses the service name `db`. Version of 2 uses a specific hostname `mlite-sik9-database`. This often works with custom networks where service discovery might use aliases or specific hostnames.
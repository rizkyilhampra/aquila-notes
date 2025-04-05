---
id: 1743844424-docker-compose-file-examples
alias: Docker compose file examples
tags: []
---
# Docker compose file examples

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
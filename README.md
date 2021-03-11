# Dockerized Phabricator

[中文](https://github.com/modi/docker-phabricator/blob/master/README.zh_CN.md)

Looking to evaluate or self-host Phabricator? Save your time by using the Alpine Linux based Docker image created by this repo.

Features work out of the box:

-   Local disk file storage
-   Git / Subversion / Mercurial repository hosting (SSH and HTTP transport)
-   Desktop notification
-   Code syntax highlighting
-   Data export to Excel
-   Chinese translation by [@arielyang](https://github.com/arielyang/phabricator_zh_Hans)

## How to Use

The quickiest way to get started is using Docker Compose.

### Running

A `docker-compose.yml` file is provided as example, make a local copy of this file or clone this repo, then start Phabricator using this command:

    docker-compose up -d

It may take a while for the container to be ready. You can use `docker logs -f` to find out what's going on inside the container.

The default homepage for Web UI is http://p.localhost:8181 .

Two more services are exposed on your host's ports:

- 2222 for SSH transport
- 22280 for notification websocket server (Aphlict)

### Configuration

Very limited for now.

A few ENV variables can be used to customize your install:

    PHA_BASE_URI=http://p.localhost:8181/
    PHA_SSH_PORT=2222
    PHA_APHLICT_CLIENT_HOST=p.localhost
    PHA_APHLICT_CLIENT_PORT=22280
    PHA_DB_HOST=db
    PHA_DB_USER=root
    PHA_DB_PASS=root

## Tips

-   All generated files (`local.json` configuration file, SSH host certificates, repositories) are stored in a data volume mounted at container path `/data`.
-   To start a shell in the container, run `docker-compose exec phabricator ash`.
-   If you prefer Debian, you can try one of these:
    -   https://github.com/bitnami/bitnami-docker-phabricator
    -   https://github.com/phabricator-docker/phabricator

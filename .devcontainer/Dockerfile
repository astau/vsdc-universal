FROM ghcr.io/astau/vsdc-base-ubuntu:latest

# Install basic build tools
RUN apt-get update \
    && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        sqlite3 \
        libsqlite3-dev \
        software-properties-common \
        tk-dev \
        uuid-dev \
        gettext \
    && rm -rf /var/lib/apt/lists/*


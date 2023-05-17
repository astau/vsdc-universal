ARG VARIANT="jammy"
FROM buildpack-deps:${VARIANT}-curl

LABEL dev.containers.features="common"

ENV LANG="C.UTF-8"

RUN apt-get update \
    && apt-get upgrade -y \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends \
        lsb-core \
        make \
        yarn \
        cloc \
        httpie \
    && rm -rf /var/lib/apt/lists/* \
    && yes | unminimize 2>&1

# ----- above this line - ubuntu and shell only tools aka "vsdc-base-ubuntu"

# FROM ghcr.io/astau/vsdc-base-ubuntu:latest

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


FROM python:3.7.3-alpine as base

RUN set -eux \
# Packages from testing
    && apk add \
        --no-cache \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
# Docker tools
        gosu \
        tini

RUN set -eux \
    && apk add \
        --no-cache  \
# Common tools for development and building
        git \
        unzip \
        curl \
        gettext \
        tzdata \
        build-base \
# Library headers to build python packages
        musl-dev \
        bzip2-dev \
        libffi-dev \
        openssl-dev \
        readline-dev \
        zlib-dev \
        postgresql-dev \
        libxml2-dev \
        libxslt-dev \
        jansson-dev \
        pcre-dev \
        bzip2-dev \
        xz-dev \
        libffi-dev \
# Requirements for generating pdf and thumbnails
        freetype-dev \
        openjpeg-dev \
        libpng-dev \
        jpeg-dev \
        lcms2-dev \
        tiff-dev

RUN set -eux \
    && apk add \
        --no-cache \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
# Postgis tools and libraries
        gdal-dev \
        geos-dev \
        proj4-dev \
        protobuf-c-dev \
# Image manipulation
        imagemagick \
        ghostscript \
# Libraries pdf weasyprint
        cairo-dev \
        pango-dev \
        gdk-pixbuf-dev \
# Installing fonts and libraries
        msttcorefonts-installer \
        ttf-opensans \
# QR Code and other generators
        libqrencode-dev \
    && update-ms-fonts \
    && fc-cache -f

ENV LANG="C.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_COLLATE="C" \
    LC_ALL="en_US.UTF-8" \
    TERM="xterm-256color" \
    PYTHONBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_TIMEOUT=60 \
    PIP_DISABLE_PIP_VERSION_CHECK=true

# Setup non-root user
RUN set -eux \
    \
    && addgroup -g 1000 app \
    && adduser -u 1000 -G app -H -D app \
    \
    && mkdir -p /app \
    && mkdir -p /python \
    && chown -R app /app \
    && chown -R app /python

ENV PATH="/python/bin:${PATH}" \
    XDG_CACHE_HOME="/python/cache" \
    DEFAULT_LOCAL_TMP="/python/cache" \
    PYTHONENV="/python" \
    PYTHONUNBUFFERED=0 \
    PYTHONHASHSEED=random

WORKDIR "/app"

EXPOSE 8000

COPY docker-entrypoint.sh /sbin/docker-entrypoint.sh

ENTRYPOINT ["tini", "--", "/sbin/docker-entrypoint.sh"]

FROM base as develop

RUN set -eux \
    && apk add --no-cache \
        bash \
        htop \
        openssh-client \
        groff \
        neovim \
        tmux \
        curl \
        unzip \
        gnupg \
        postgresql-client \
# Setup neovim as the replacement for vim.
    && ln -s $(which nvim) /usr/local/bin/vim

COPY docker-entrypoint-develop.sh /sbin/docker-entrypoint.sh


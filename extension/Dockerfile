ARG PG_VERSION_TAG=pg12
ARG TIMESCALEDB_VERSION=1.7.0
FROM timescale/timescaledb:${TIMESCALEDB_VERSION}-${PG_VERSION_TAG}

MAINTAINER Timescale https://www.timescale.com

RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
                coreutils \
                dpkg-dev dpkg \
                gcc \
                libc-dev \
                make \
                util-linux-dev \
                clang \
		        llvm \
                git
RUN set -ex \
    && git clone  --branch v1.9 --depth 1 \
         https://github.com/dimitri/pgextwlist.git /pgextwlist \
    && cd /pgextwlist \
    && make \
    && make install \
    && cp /pgextwlist/pgextwlist.so `pg_config --pkglibdir`/plugins \
    && rm -rf /pgextwlist

COPY timescale_prometheus_extra.control Makefile /build/timescale-prometheus/
COPY src/*.c src/*.h /build/timescale-prometheus/src/
COPY sql/timescale-prometheus.sql /build/timescale-prometheus/sql/

RUN set -ex \
    && make -C /build/timescale-prometheus install \
    \
    && apk del .build-deps \
    && rm -rf /build

COPY 003-enable-pgextwlist.sh /docker-entrypoint-initdb.d/

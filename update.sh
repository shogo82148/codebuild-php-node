#!/bin/sh

(
    cd ubuntu/1.0 && \
    echo updating php7.1 node10 standard-1.0 >&2 && \
    ./update.pl 7.1 10 && \
    echo updating php7.1 node12 standard-1.0 >&2 && \
    ./update.pl 7.1 12 && \
    echo updating php7.2 node10 standard-1.0 >&2 && \
    ./update.pl 7.2 10 && \
    echo updating php7.2 node12 standard-1.0 >&2 && \
    ./update.pl 7.2 12 && \
    echo updating php7.3 node10 standard-1.0 >&2 && \
    ./update.pl 7.3 10 && \
    echo updating php7.3 node12 standard-1.0 >&2 && \
    ./update.pl 7.3 12 \
    echo updating php7.4 node10 standard-2.0 >&2 && \
    ./update.pl 7.4 10 && \
    echo updating php7.4 node12 standard-2.0 >&2 && \
    ./update.pl 7.4 12
) || exit 1

(
    cd ubuntu/2.0 && \
    echo updating php7.1 node10 standard-2.0 >&2 && \
    ./update.pl 7.1 10 && \
    echo updating php7.1 node12 standard-2.0 >&2 && \
    ./update.pl 7.1 12 && \
    echo updating php7.2 node10 standard-2.0 >&2 && \
    ./update.pl 7.2 10 && \
    echo updating php7.2 node12 standard-2.0 >&2 && \
    ./update.pl 7.2 12 && \
    echo updating php7.3 node10 standard-2.0 >&2 && \
    ./update.pl 7.3 10 && \
    echo updating php7.3 node12 standard-2.0 >&2 && \
    ./update.pl 7.3 12 \
    echo updating php7.4 node10 standard-2.0 >&2 && \
    ./update.pl 7.4 10 && \
    echo updating php7.4 node12 standard-2.0 >&2 && \
    ./update.pl 7.4 12
) || exit 1

(
    cd ubuntu/3.0 && \
    echo updating php7.1 node10 standard-2.0 >&2 && \
    ./update.pl 7.1 10 && \
    echo updating php7.1 node12 standard-2.0 >&2 && \
    ./update.pl 7.1 12 && \
    echo updating php7.2 node10 standard-2.0 >&2 && \
    ./update.pl 7.2 10 && \
    echo updating php7.2 node12 standard-2.0 >&2 && \
    ./update.pl 7.2 12 && \
    echo updating php7.3 node10 standard-2.0 >&2 && \
    ./update.pl 7.3 10 && \
    echo updating php7.3 node12 standard-2.0 >&2 && \
    ./update.pl 7.3 12 \
    echo updating php7.4 node10 standard-2.0 >&2 && \
    ./update.pl 7.4 10 && \
    echo updating php7.4 node12 standard-2.0 >&2 && \
    ./update.pl 7.4 12
) || exit 1

(
    cd al2/1.0 && \
    echo updating php7.1 node10 amazonlinux2-1.0 >&2 && \
    ./update.pl 7.1 10 && \
    echo updating php7.1 node12 amazonlinux2-1.0 >&2 && \
    ./update.pl 7.1 12 && \
    echo updating php7.2 node10 amazonlinux2-1.0 >&2 && \
    ./update.pl 7.2 10 && \
    echo updating php7.2 node12 amazonlinux2-1.0 >&2 && \
    ./update.pl 7.2 12 && \
    echo updating php7.3 node10 amazonlinux2-1.0 >&2 && \
    ./update.pl 7.3 10 && \
    echo updating php7.3 node12 amazonlinux2-1.0 >&2 && \
    ./update.pl 7.3 12 \
    echo updating php7.4 node10 amazonlinux2-1.0 >&2 && \
    ./update.pl 7.4 10 && \
    echo updating php7.4 node12 amazonlinux2-1.0 >&2 && \
    ./update.pl 7.4 12
)

(
    cd al2/2.0 && \
    echo updating php7.1 node10 amazonlinux2-2.0 >&2 && \
    ./update.pl 7.1 10 && \
    echo updating php7.1 node12 amazonlinux2-2.0 >&2 && \
    ./update.pl 7.1 12 && \
    echo updating php7.2 node10 amazonlinux2-2.0 >&2 && \
    ./update.pl 7.2 10 && \
    echo updating php7.2 node12 amazonlinux2-2.0 >&2 && \
    ./update.pl 7.2 12 && \
    echo updating php7.3 node10 amazonlinux2-2.0 >&2 && \
    ./update.pl 7.3 10 && \
    echo updating php7.3 node12 amazonlinux2-2.0 >&2 && \
    ./update.pl 7.3 12 \
    echo updating php7.4 node10 amazonlinux2-2.0 >&2 && \
    ./update.pl 7.4 10 && \
    echo updating php7.4 node12 amazonlinux2-2.0 >&2 && \
    ./update.pl 7.4 12
) || exit 1

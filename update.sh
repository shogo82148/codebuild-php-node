#!/bin/sh

(
    cd ubuntu/1.0 && \
    ./update.pl 7.2 10 && \
    ./update.pl 7.2 12 && \
    ./update.pl 7.3 10 && \
    ./update.pl 7.3 12
)

(
    cd ubuntu/2.0 && \
    ./update.pl 7.2 10 && \
    ./update.pl 7.2 12 && \
    ./update.pl 7.3 10 && \
    ./update.pl 7.3 12
)

(
    cd al2/1.0 && \
    ./update.pl 7.2 10 && \
    ./update.pl 7.2 12 && \
    ./update.pl 7.3 10 && \
    ./update.pl 7.3 12
)

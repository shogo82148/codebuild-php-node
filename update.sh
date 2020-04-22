#!/bin/sh

for PHP in 7.1 7.2 7.3 7.4
do
    for NODE in 10 12 14
    do

        for STANDARD in 1.0 2.0 3.0 4.0
        do
        (
            cd "ubuntu/$STANDARD" && \
            echo updating "php$PHP" "node$NODE" "standard-$STANDARD" >&2 && \
            ./update.pl "$PHP" "$NODE"
        ) || exit 1
        done

        for AL2 in 1.0 2.0 3.0
        do
        (
            cd "al2/$AL2" && \
            echo updating "php$PHP" "node$NODE" "amazonlinux2-$AL2" >&2 && \
            ./update.pl "$PHP" "$NODE"
        ) || exit 1
        done

    done
done

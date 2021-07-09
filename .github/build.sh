#!/bin/bash

set -uex

WORDDIR=$1
BASE_IMAGE=$2
BASE_IMAGE_VERSION=$3
ROOT=$(cd "$(dirname "$0")" && cd .. && pwd)

for PHP in 8.0 7.4 7.3
do
    for NODE in 16 14 12
    do
        echo "::group::php$PHP-node$NODE"
        TAG=shogo82148/codebuild-php-node:php$PHP-node$NODE-$BASE_IMAGE-$BASE_IMAGE_VERSION
        docker build "$ROOT/$WORDDIR/$BASE_IMAGE_VERSION/php$PHP/node$NODE" --tag "$TAG"

        if [[ ${GITHUB_REF} = 'refs/heads/main' ]]; then
            # Publish to the Docker Hub
            printenv PASSWORD | docker login -u "$USERNAME" --password-stdin
            docker push "$TAG"
            docker logout
        fi
        echo "::endgroup::"
    done
done

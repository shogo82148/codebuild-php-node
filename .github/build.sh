#!/bin/bash

set -uex

WORDDIR=$1
BASE_IMAGE=$2
BASE_IMAGE_VERSION=$3
ROOT=$(cd "$(dirname "$0")" && cd .. && pwd)

for PHP in 8.0 7.4 7.3 7.2
do
    for NODE in 14 12 10
    do
        echo "::group::php$PHP-node$NODE"
        TAG=shogo82148/codebuild-php-node:php$PHP-node$NODE-$BASE_IMAGE-$BASE_IMAGE_VERSION
        PACKAGE=docker.pkg.github.com/$GITHUB_REPOSITORY/php$PHP-node$NODE-$BASE_IMAGE-$BASE_IMAGE_VERSION:latest
        docker build "$ROOT/$WORDDIR/$BASE_IMAGE_VERSION/php$PHP/node$NODE" --tag "$TAG"

        if [[ ${GITHUB_REF} = 'refs/heads/main' ]]; then
            # Publish to the Docker Hub
            printenv PASSWORD | docker login -u "$USERNAME" --password-stdin
            docker push "$TAG"
            docker logout

            # Publish to the GitHub package registry
            printenv TOKEN | docker login docker.pkg.github.com -u "$USERNAME" --password-stdin
            docker tag "$TAG" "$PACKAGE"
            docker push "$PACKAGE"
            docker logout docker.pkg.github.com
        fi
        echo "::endgroup::"
    done
done

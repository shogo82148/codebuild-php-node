# Copyright 2017-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# Copyright 2019 Shogo Ichinose. All Rights Reserved.
#
# Licensed under the Amazon Software License (the "License"). You may not use this file except in compliance with the License.
# A copy of the License is located at
#
#    http://aws.amazon.com/asl/
#
# or in the "license" file accompanying this file.
# This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or implied.
# See the License for the specific language governing permissions and limitations under the License.
#

FROM ubuntu:18.04

ENV DOCKER_BUCKET="download.docker.com" \
    DOCKER_VERSION="18.09.0" \
    DOCKER_CHANNEL="stable" \
    DOCKER_SHA256="08795696e852328d66753963249f4396af2295a7fe2847b839f7102e25e47cb9" \
    DIND_COMMIT="3b5fac462d21ca164b3778647420016315289034" \
    DOCKER_COMPOSE_VERSION="1.23.2" \
    GITVERSION_VERSION="3.6.5"

ENV DEBIAN_FRONTEND=noninteractive

# Install git, SSH, and other utilities
RUN set -ex \
    && echo 'Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/99use-gzip-compression \
    && apt-get update \
    && apt install -y apt-transport-https ca-certificates gnupg2 \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
    && apt-get update \
    && apt-get install git -y --no-install-recommends \
    && git version \
    && apt-get install -y --no-install-recommends openssh-client=1:7.6* \
    && mkdir ~/.ssh \
    && touch ~/.ssh/known_hosts \
    && ssh-keyscan -t rsa,dsa -H github.com >> ~/.ssh/known_hosts \
    && ssh-keyscan -t rsa,dsa -H bitbucket.org >> ~/.ssh/known_hosts \
    && chmod 600 ~/.ssh/known_hosts \
    && apt-get install -y --no-install-recommends \
        wget=1.19.* python3=3.6.* python3.6-dev=3.6.* fakeroot=1.22-* jq \
        tar=1.29* gzip=1.6-* zip=3.0-* autoconf=2.69-* automake=1:1.15.* \
        bzip2=1.0.* file=1:5.32-* g++=4:7.3.* gcc=4:7.3.* imagemagick=8:6.9.* \
        libbz2-dev=1.0.* libc6-dev=2.27-* libcurl4-openssl-dev=7.58.* libdb-dev=1:5.3.* \
        libevent-dev=2.1.* libffi-dev=3.2.* libgeoip-dev=1.6.* libglib2.0-dev=2.56.* \
        libjpeg-dev=8c-* libkrb5-dev=1.16-* liblzma-dev=5.2.* \
        libmagickcore-dev=8:6.9.* libmagickwand-dev=8:6.9.* libmysqlclient-dev=5.7.* \
        libncurses5-dev=6.1-* libpng-dev=1.6.* libpq-dev=10.6-* libreadline-dev=7.0-* \
        libsqlite3-dev=3.22.* libssl-dev=1.1.* libtool=2.4.* libwebp-dev=0.6.* \
        libxml2-dev=2.9.* libxslt1-dev=1.1.* libyaml-dev=0.1.* make=4.1-* \
        patch=2.7.* xz-utils=5.2.* zlib1g-dev=1:1.2.* unzip=6.0-* curl=7.58.* \
        e2fsprogs=1.44.* iptables=1.6.* xfsprogs=4.9.* \
        mono-devel=5.* less=487-* groff=1.22.* liberror-perl=0.17* \
        asciidoc=8.6.* build-essential=12.* bzr=2.7.* cvs=2:1.12.* cvsps=2.1-* docbook-xml=4.5-* docbook-xsl=1.79.* dpkg-dev=1.19.* \
        libdbd-sqlite3-perl=1.56-* libdbi-perl=1.640-* libdpkg-perl=1.19.* libhttp-date-perl=6.02-* \
        libio-pty-perl=1:1.08-* libserf-1-1=1.3.* libsvn-perl=1.9.* libsvn1=1.9.* libtcl8.6=8.6.* libtimedate-perl=2.3000-* \
        libxml2-utils=2.9.* libyaml-perl=1.24-* python-bzrlib=2.7.* python-configobj=5.0.* \
        sgml-base=1.29* sgml-data=2.0.* subversion=1.9.* tcl=8.6.* tcl8.6=8.6.* xml-core=0.18* xmlto=0.0.* xsltproc=1.1.* python3-pip python3-setuptools \
        tk=8.6.* gettext=0.19.* gettext-base=0.19.* libapr1=1.6.* libaprutil1=1.6.* \
        libargon2-0 libargon2-0-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Download and set up GitVersion
RUN set -ex \
    && wget "https://github.com/GitTools/GitVersion/releases/download/v${GITVERSION_VERSION}/GitVersion_${GITVERSION_VERSION}.zip" -O /tmp/GitVersion_${GITVERSION_VERSION}.zip \
    && mkdir -p /usr/local/GitVersion_${GITVERSION_VERSION} \
    && unzip /tmp/GitVersion_${GITVERSION_VERSION}.zip -d /usr/local/GitVersion_${GITVERSION_VERSION} \
    && rm /tmp/GitVersion_${GITVERSION_VERSION}.zip \
    && echo "mono /usr/local/GitVersion_${GITVERSION_VERSION}/GitVersion.exe \$@" >> /usr/local/bin/gitversion \
    && chmod +x /usr/local/bin/gitversion

# Install Docker
RUN set -ex \
    && curl -fSL "https://${DOCKER_BUCKET}/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
    && echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
    && tar --extract --file docker.tgz --strip-components 1  --directory /usr/local/bin/ \
    && rm docker.tgz \
    && docker -v \
# set up subuid/subgid so that "--userns-remap=default" works out-of-the-box
    && addgroup dockremap \
    && useradd -g dockremap dockremap \
    && echo 'dockremap:165536:65536' >> /etc/subuid \
    && echo 'dockremap:165536:65536' >> /etc/subgid \
    && wget "https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind" -O /usr/local/bin/dind \
    && curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/dind /usr/local/bin/docker-compose \
# Ensure docker-compose works
    && docker-compose version

# Install dependencies by all python images equivalent to buildpack-deps:jessie
# on the public repos.

RUN set -ex \
    && pip3 install awscli boto3

VOLUME /var/lib/docker

# Configure SSH
COPY ssh_config /root/.ssh/config

COPY dockerd-entrypoint.sh /usr/local/bin/


ENV GPG_KEYS CBAF69F173A0FEA4B537F470D66C9593118BCCB6 F38252826ACD957EF380D39F2F7956BC5DA04B5D
ENV SRC_DIR="/usr/src" \
    PHP_VERSION=7.3.1 \
    PHP_DOWNLOAD_SHA="cfe93e40be0350cd53c4a579f52fe5d8faf9c6db047f650a4566a2276bf33362" \
    PHPPATH="/php" \
    PHP_INI_DIR="/usr/local/etc/php" \
    PHP_CFLAGS="-fstack-protector -fpic -fpie -O2" \
    PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

ENV PHP_SRC_DIR="$SRC_DIR/php" \
    PHP_CPPFLAGS="$PHP_CFLAGS" \
    PHP_URL="https://secure.php.net/get/php-$PHP_VERSION.tar.xz/from/this/mirror" \
    PHP_ASC_URL="https://secure.php.net/get/php-$PHP_VERSION.tar.xz.asc/from/this/mirror"

# Install PHP
RUN set -xe; \
    mkdir -p $SRC_DIR; \
    cd $SRC_DIR; \
    wget -O php.tar.xz "$PHP_URL"; \
    echo "$PHP_DOWNLOAD_SHA *php.tar.xz" | sha256sum -c -; \
    wget -O php.tar.xz.asc "$PHP_ASC_URL"; \
    export GNUPGHOME="$(mktemp -d)"; \
    for key in $GPG_KEYS; do \
        gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
        gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
        gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
    done; \
    gpg --batch --verify php.tar.xz.asc php.tar.xz; \
    rm -rf "$GNUPGHOME"; \
    set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends libedit-dev=3.1-* dpkg-dev=1.19.*; \
    rm -rf /var/lib/apt/lists/*; \
    apt-get clean; \
    export \
        CFLAGS="$PHP_CFLAGS" \
        CPPFLAGS="$PHP_CPPFLAGS" \
        LDFLAGS="$PHP_LDFLAGS" \
    ; \
    mkdir -p $PHP_SRC_DIR; \
    tar -Jxf $SRC_DIR/php.tar.xz -C $PHP_SRC_DIR --strip-components=1; \
    cd $SRC_DIR/php; \
    gnuArch="$(dpkg-architecture -qDEB_BUILD_GNU_TYPE)"; \
    debMultiarch="$(dpkg-architecture -qDEB_BUILD_MULTIARCH)"; \
    # https://bugs.php.net/bug.php?id=74125
    if [ ! -d /usr/include/curl ]; then \
        ln -sT "/usr/include/$debMultiarch/curl" /usr/local/include/curl; \
    fi; \
    ./configure \
        --build="$gnuArch" \
        --with-config-file-path="$PHP_INI_DIR" \
        --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
        --disable-cgi \
    # --enable-ftp is included here because ftp_ssl_connect() needs ftp to be compiled statically (see https://github.com/docker-library/php/issues/236)
        --enable-ftp \
    # --enable-mbstring is included here because otherwise there's no way to get pecl to use it properly (see https://github.com/docker-library/php/issues/195)
        --enable-mbstring \
    # --enable-mysqlnd is included here because it's harder to compile after the fact than extensions are (since it's a plugin for several extensions, not an extension in itself)
        --enable-mysqlnd \
        --enable-sockets \
        --enable-pcntl \
    # https://wiki.php.net/rfc/argon2_password_hash (7.2+)
        --with-password-argon2 \
        --with-curl \
        --with-pdo-pgsql \
        --with-pdo-mysql \
        --with-libedit \
        --with-openssl \
        --with-zlib \
    # bundled pcre does not support JIT on s390x
    # https://manpages.debian.org/stretch/libpcre3-dev/pcrejit.3.en.html#AVAILABILITY_OF_JIT_SUPPORT
    $(test "$gnuArch" = 's390x-linux-gnu' && echo '--without-pcre-jit') \
        --with-libdir="lib/$debMultiarch" \
    ${PHP_EXTRA_CONFIGURE_ARGS:-} \
    ; \
    make -j "$(nproc)"; \
    # FIXME: :(
    # make test; \
    make install; \
    find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; \
    make clean; \
    cd /; \
    rm -rf $PHP_SRC_DIR; \
    # reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
    apt-mark auto '.*' > /dev/null; \
    [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
    find /usr/local -type f -executable -exec ldd '{}' ';' \
        | awk '/=>/ { print $(NF-1) }' \
        | sort -u \
        | xargs -r dpkg-query --search \
        | cut -d: -f1 \
        | sort -u \
        | xargs -r apt-mark manual \
    ; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    php --version; \
    pecl update-channels; \
    rm -rf /tmp/pear ~/.pearrc; \
    # Increase the memory size, default is 128M
    mkdir "$PHP_INI_DIR"; \
    mkdir "$PHP_INI_DIR/conf.d"; \
    touch "$PHP_INI_DIR/conf.d/memory.ini" \
    && echo "memory_limit = 1G;" >> "$PHP_INI_DIR/conf.d/memory.ini";

ENV PATH="$PHPPATH/bin:/usr/local/php/bin:$PATH"

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

ENV NODE_VERSION="10.15.0"

# gpg keys listed at https://github.com/nodejs/node#release-team
RUN set -ex \
    && for key in \
      94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
     FD3A5288F042B6850C66B31F09FE44734EB7990E \
     71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
     DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
     C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
     B9AE9905FFD7803F25714661B63B535A4C206CA9 \
     77984A986EBC2AA786BC0F66B01FBB92821C587A \
     8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
     4ED778F539E3634C779C87C6D7062848A1AB005C \
     A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
     B9E2F5981AA6E0CD28160D9FF13993A75599653C \
    ; do \
      gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
      gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
      gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
    done

RUN set -ex \
	&& wget "https://nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" -O node-v$NODE_VERSION-linux-x64.tar.gz \
	&& wget "https://nodejs.org/download/release/v$NODE_VERSION/SHASUMS256.txt.asc" -O SHASUMS256.txt.asc \
	&& gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
	&& grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt | sha256sum -c - \
		&& tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
		&& rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc SHASUMS256.txt \
		&& ln -s /usr/local/bin/node /usr/local/bin/nodejs \
		&& rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN npm set unsafe-perm true

ENV YARN_VERSION %%YARN_VERSION%%

RUN set -ex \
    && for key in \
        %%YARN_GPG_KEY%% \
    ; do \
        gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
        gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
        gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
    done \
    && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
    && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
    && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
    && mkdir -p /opt \
    && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
    && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
    && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz

WORKDIR $PHPPATH

# Copyright 2017-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Amazon Software License (the "License"). You may not use this file except in compliance with the License.
# A copy of the License is located at
#
#    http://aws.amazon.com/asl/
#
# or in the "license" file accompanying this file.
# This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or implied.
# See the License for the specific language governing permissions and limitations under the License.

FROM amazonlinux:2

ENV PYTHON_VERSION="3.7.3" \
 PHP_VERSION="7.3.9" \
 NODE_VERSION="10.16.3" \
 JQ_VERSION="1.6" \
 JQ_SHA256="af986793a515d500ab2d35f8d2aecd656e764504b789b66d7e1a0b727a124c44" \
 DOCKER_VERSION="18.09.6" \
 DOCKER_COMPOSE_VERSION="1.24.0"

#****************        Utilities     ********************************************* 
ENV DOCKER_BUCKET="download.docker.com" \    
    DOCKER_CHANNEL="stable" \
    DOCKER_SHA256="1f3f6774117765279fce64ee7f76abbb5f260264548cf80631d68fb2d795bb09" \
    DIND_COMMIT="3b5fac462d21ca164b3778647420016315289034" \    
    GITVERSION_VERSION="4.0.0" \
    DEBIAN_FRONTEND="noninteractive" \
    SRC_DIR="/usr/src" \
    EPEL_REPO="https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm" \
    TRINITY_REPO="https://mirror.ppa.trinitydesktop.org/trinity/trinity/rpm/el7/trinity-r14/RPMS/noarch/trinity-repo-14.0.5-1.el7.noarch.rpm"

# Install git, SSH, and other utilities
RUN set -ex \
    && yum install -y openssh-clients \
    && mkdir ~/.ssh \
    && touch ~/.ssh/known_hosts \
    && ssh-keyscan -t rsa,dsa -H github.com >> ~/.ssh/known_hosts \
    && ssh-keyscan -t rsa,dsa -H bitbucket.org >> ~/.ssh/known_hosts \
    && chmod 600 ~/.ssh/known_hosts \
    && yum install -y $EPEL_REPO $TRINITY_REPO \
    && yum groupinstall -y "Development tools" \
    && yum install -y wget fakeroot \
       dirmngr bzr mercurial procps-ng \
       ImageMagick \
       openssl-devel libdb-devel \
       libevent-devel libffi-devel GeoIP-devel glib2-devel \
       libjpeg-devel krb5-server xz-devel \
       mariadb-devel \
       ncurses-devel postgresql-devel readline-devel \
       libsqlite3x-devel libwebp-devel \
       libxml2-devel libxslt-devel libyaml-devel \
       e2fsprogs iptables xfsprogs \
       groff \
       asciidoc cvs cvsps docbook-dtds docbook-style-xsl \
       perl-DBD-SQLite perl-DBI perl-HTTP-Date \
       perl-IO-Pty-Easy libserf subversion-perl tcl perl-TimeDate \
       perl-YAML-LibYAML bzrtools python-configobj \
       sgml-common xmlto libxslt \
       tk expect parallel rsync \
    && rm -rf /var/cache/yum/* \
    && yum clean all \
    && wget https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 -O /usr/local/bin/jq \
    && echo "$JQ_SHA256 /usr/local/bin/jq" | sha256sum -c - \
    && chmod +x /usr/local/bin/jq

# Install Docker
RUN set -ex \
    && curl -fSL "https://${DOCKER_BUCKET}/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
    && echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
    && tar --extract --file docker.tgz --strip-components 1  --directory /usr/local/bin/ \
    && rm docker.tgz \
    && docker -v \
# set up subuid/subgid so that "--userns-remap=default" works out-of-the-box
    && groupadd dockremap \
    && useradd -g dockremap dockremap \
    && echo 'dockremap:165536:65536' >> /etc/subuid \
    && echo 'dockremap:165536:65536' >> /etc/subgid \
    && wget "https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind" -O /usr/local/bin/dind \
    && curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/dind /usr/local/bin/docker-compose \
# Ensure docker-compose works
    && docker-compose version

# https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_CLI_installation.html
RUN curl -sS -o /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator \
 && curl -sS -o /usr/local/bin/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/kubectl \
 && curl -sS -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest \
 && chmod +x /usr/local/bin/kubectl /usr/local/bin/aws-iam-authenticator /usr/local/bin/ecs-cli

VOLUME /var/lib/docker

# Configure SSH
COPY ssh_config /root/.ssh/config

COPY runtimes.yml /codebuild/image/config/runtimes.yml

COPY dockerd-entrypoint.sh /usr/local/bin/

#****************        PYTHON     *********************************************
ENV PATH="/usr/local/bin:$PATH" \
    GPG_KEY="0D96DF4D4110E5C43FBFB17F2D347EA6AA65421D" \
    PYTHON_PIP_VERSION="19.1.1" \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

RUN yum install -y tcl-devel tk-devel bzip2-devel gdbm-devel libuuid-devel \
    && wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
    && wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && (gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$GPG_KEY" \
        || gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "$GPG_KEY" \
        || gpg --keyserver pgp.mit.edu --recv-keys "$GPG_KEY") \
    && gpg --batch --verify python.tar.xz.asc python.tar.xz \
    && rm -r "$GNUPGHOME" python.tar.xz.asc \
    && mkdir -p /usr/src/python \
    && tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
    && rm python.tar.xz \
    \
    && cd /usr/src/python \
    && ./configure \
        --enable-loadable-sqlite-extensions \
        --enable-shared \
    && make -j$(nproc) \
    && make install \
    && ln -s /usr/local/lib/libpython3.7m.so.1.0 /usr/lib/libpython3.7m.so.1.0 \
    && ldconfig \
# explicit path to "pip3" to ensure distribution-provided "pip3" cannot interfere
    && if [ ! -e /usr/local/bin/pip3 ]; then : \
        && wget -O /tmp/get-pip.py 'https://bootstrap.pypa.io/get-pip.py' \
        && python3 /tmp/get-pip.py "pip==$PYTHON_PIP_VERSION" \
        && rm /tmp/get-pip.py \
    ; fi \
# we use "--force-reinstall" for the case where the version of pip we're trying to install is the same as the version bundled with Python
# ("Requirement already up-to-date: pip==8.1.2 in /usr/local/lib/python3.6/site-packages")
# https://github.com/docker-library/python/pull/143#issuecomment-241032683
    && pip3 install --no-cache-dir --upgrade --force-reinstall "pip==$PYTHON_PIP_VERSION" \
        && pip install pipenv virtualenv --no-cache-dir \
        && pip3 install --no-cache-dir --upgrade setuptools wheel \
# then we use "pip list" to ensure we don't have more than one pip version installed
# https://github.com/docker-library/python/pull/100
    && [ "$(pip list |tac|tac| awk -F '[ ()]+' '$1 == "pip" { print $2; exit }')" = "$PYTHON_PIP_VERSION" ] \
    \
    && find /usr/local -depth \
        \( \
            \( -type d -a -name test -o -name tests \) \
            -o \
            \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        \) -exec rm -rf '{}' + \
    && rm -rf /usr/src/python ~/.cache \
    && cd /usr/local/bin \
    && { [ -e easy_install ] || ln -s easy_install-* easy_install; } \
    && ln -s idle3 idle \
    && ln -s pydoc3 pydoc \
    && ln -s python3 python \
    && ln -s python3-config python-config \
    && rm -rf /var/cache/yum/* \
    && yum clean all
#****************      END PYTHON     *********************************************

ENV PATH="/root/.local/bin:$PATH"

RUN set -ex \
    && pip3 install --user aws-sam-cli \
    && sam --version \
    && pip3 install awscli boto3

#****************      PHP     ****************************************************
 ENV GPG_KEYS CBAF69F173A0FEA4B537F470D66C9593118BCCB6 F38252826ACD957EF380D39F2F7956BC5DA04B5D
 ENV PHP_DOWNLOAD_SHA="4007f24a39822bef2805b75c625551d30be9eeed329d52eb0838fa5c1b91c1fd" \
     PHPPATH="/php" \
     PHP_INI_DIR="/usr/local/etc/php" \
     PHP_CFLAGS="-fstack-protector -fpic -fpie -O2" \
     PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"
 ENV PHP_SRC_DIR="$SRC_DIR/php" \
     PHP_CPPFLAGS="$PHP_CFLAGS" \
     PHP_URL="https://secure.php.net/get/php-$PHP_VERSION.tar.xz/from/this/mirror" \
     PHP_ASC_URL="https://secure.php.net/get/php-$PHP_VERSION.tar.xz.asc/from/this/mirror"
 RUN set -xe; \
     mkdir -p $SRC_DIR; \
     cd $SRC_DIR; \
     yum install -y curl-devel; \
     wget -O php.tar.xz "$PHP_URL"; \
     echo "$PHP_DOWNLOAD_SHA *php.tar.xz" | sha256sum -c -; \
     wget -O php.tar.xz.asc "$PHP_ASC_URL"; \
     export GNUPGHOME="$(mktemp -d)"; \
     for key in $GPG_KEYS; do \
         ( gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" \
           || gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "$key" \
           || gpg --keyserver pgp.mit.edu --recv-keys "$key" ); \
     done; \
     gpg --batch --verify php.tar.xz.asc php.tar.xz; \
     rm -rf "$GNUPGHOME"; \
     set -eux; \
     yum install -y libedit-devel dpkg-dev libargon2-devel re2c; \
     export \
         CFLAGS="$PHP_CFLAGS" \
         CPPFLAGS="$PHP_CPPFLAGS" \
         LDFLAGS="$PHP_LDFLAGS" \
     ; \
     mkdir -p $PHP_SRC_DIR; \
     tar -Jxf $SRC_DIR/php.tar.xz -C $PHP_SRC_DIR --strip-components=1; \
     cd $PHP_SRC_DIR; \
     gnuArch="$(dpkg-architecture -qDEB_BUILD_GNU_TYPE)"; \
     debMultiarch="$(dpkg-architecture -qDEB_BUILD_MULTIARCH)"; \
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
     $(test "$gnuArch" = 's390x-linux-gnu' && echo '--without-pcre-jit') \
         --with-libdir="lib/$debMultiarch" \
     ${PHP_EXTRA_CONFIGURE_ARGS:-} \
     ; \
     make -j "$(nproc)"; \
     make install; \
     find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; \
     make clean; \
     cd /; \
     rm -rf $PHP_SRC_DIR; \
     rm $SRC_DIR/php.tar.xz; \
     php --version; \
     pecl update-channels; \
     rm -rf /tmp/pear ~/.pearrc; \
     mkdir "$PHP_INI_DIR"; \
     mkdir "$PHP_INI_DIR/conf.d"; \
     touch "$PHP_INI_DIR/conf.d/memory.ini" \
     && echo "memory_limit = 1G;" >> "$PHP_INI_DIR/conf.d/memory.ini"; \
     rm -rf /var/cache/yum/* && yum clean all

 ENV PATH="$PHPPATH/bin:/usr/local/php/bin:$PATH"

 # Install Composer globally
 RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
#****************      END PHP     ****************************************************

#****************      NODEJS     ****************************************************

 ENV N_SRC_DIR="$SRC_DIR/n"

 RUN git clone https://github.com/tj/n $N_SRC_DIR \
    && cd $N_SRC_DIR && make install \
    && n $NODE_VERSION && npm install --save-dev -g grunt && npm install --save-dev -g grunt-cli && npm install --save-dev -g webpack \
    && curl -sSL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo \
    && rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg \
    && yum install -y yarn \
    && yarn --version \
    && cd / && rm -rf $N_SRC_DIR \
    && rm -rf /var/cache/yum/* \
    && yum clean all

#****************      END NODEJS     ****************************************************

ENTRYPOINT ["dockerd-entrypoint.sh"]

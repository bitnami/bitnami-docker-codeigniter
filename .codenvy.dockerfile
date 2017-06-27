FROM gcr.io/stacksmith-images/minideb-buildpack:jessie-r11

MAINTAINER Bitnami <containers@bitnami.com>

RUN echo 'deb http://ftp.debian.org/debian jessie-backports main' >> /etc/apt/sources.list
RUN apt-get update && apt-get install -t jessie-backports -y openjdk-8-jdk-headless
RUN install_packages git subversion openssh-server rsync
RUN mkdir /var/run/sshd && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV BITNAMI_APP_NAME=che-codeigniter \
    BITNAMI_IMAGE_VERSION=3.1.3-r3 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# System packages required
RUN install_packages libc6 zlib1g libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libsybdb5 libmcrypt4 libldap-2.4-2 libstdc++6 libgmp10 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libssl1.0.0 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 libgssapi-krb5-2 libgnutls-deb0-28 libsasl2-2 liblzma5 libidn11 librtmp1 libssh2-1 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libkrb5support0 libkeyutils1 libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libffi6 libaio1 libjemalloc1

# Install CodeIgniter dependencies
RUN bitnami-pkg install php-7.0.20-0 --checksum 78181d1320567be07448e75e4783ce0269b433fc9e7ed8eff67abcff7f7327e9
RUN bitnami-pkg install mysql-client-10.1.24-0 --checksum 3ac33998eefe09a8013036d555f2a8265fc446a707e8d61c63f8621f4a3e5dae
RUN bitnami-pkg install mariadb-10.1.24-1 --checksum 0ad8567f9d3d8371f085b56854b5288be38c85a5cb3cd4e36d8355eb6bbbd4cd

# Install CodeIgniter module
RUN bitnami-pkg install codeigniter-3.1.3-0 --checksum 5d653ed41a2bf4f78818f5cb2c249fba83b9f041ca72a8d7a5f7c9c6d9d51131 -- --applicationDirectory /projects

EXPOSE 8000

# Set up Codenvy integration
LABEL che:server:8000:ref=codeigniter che:server:8000:protocol=http

USER bitnami
WORKDIR /projects

ENV TERM=xterm

CMD sudo /usr/sbin/sshd && sudo HOME=/root /opt/bitnami/nami/bin/nami start --foreground mariadb

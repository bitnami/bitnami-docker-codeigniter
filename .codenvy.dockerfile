FROM gcr.io/stacksmith-images/minideb-buildpack:jessie-r3

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=che-codeigniter \
    BITNAMI_IMAGE_VERSION=che-3.1.0-r6 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Install CodeIgniter dependencies
RUN bitnami-pkg install php-7.0.11-1 --checksum cc9129523269e86728eb81ac489c65996214f22c6447bbff4c2306ec4be3c871
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976
RUN bitnami-pkg install mariadb-10.1.17-1 --checksum 003be4c827669dae149d4a4639dfc7dcb5766b76aeccf477b4912ae000290768

# Install CodeIgniter module
RUN bitnami-pkg install codeigniter-3.1.0-2 --checksum 00f4e413b46969bc31e1df5db8a54814eb1b221c30da7e8ec4911ac69b41d33c -- --applicationDirectory /projects

EXPOSE 8000

# Set up Codenvy integration
LABEL che:server:8000:ref=codeigniter che:server:8000:protocol=http

USER bitnami
WORKDIR /projects

ENV TERM=xterm

CMD [ "sudo", "HOME=/root", "/opt/bitnami/nami/bin/nami", "start", "--foreground", "mariadb"]

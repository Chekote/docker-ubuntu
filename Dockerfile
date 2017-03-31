# chekote/ubuntu:precise
FROM ubuntu:precise

ENV DEBIAN_FRONTEND noninteractive

    # Fix 'setlocale: LC_ALL: cannot change local (en_US.UTF-8)'
RUN locale-gen en_US.UTF-8 && \

    # Fix 'debconf: delaying package configuration, since apt-utils is not installed'
    apt-get update && \
    apt-get install -y apt-utils && \

    # Fix -u may not run as fully supported user (no home, no /etc/passwd entry, etc). See entrypoint.sh
    apt-get install -y curl && \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture)"  && \
    curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture).asc"  && \
    gpg --verify /usr/local/bin/gosu.asc  && \
    rm /usr/local/bin/gosu.asc  && \
    chmod +x /usr/local/bin/gosu  && \

    # Cleanup
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

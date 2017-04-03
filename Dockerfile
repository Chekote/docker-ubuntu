# chekote/ubuntu:zesty
FROM ubuntu:zesty

ENV DEBIAN_FRONTEND noninteractive

    # Fix 'setlocale: LC_ALL: cannot change local (en_US.UTF-8)'
RUN locale-gen en_US.UTF-8 && \

    # Fix 'debconf: delaying package configuration, since apt-utils is not installed'
    apt-get update && \
    apt-get install -y apt-utils && \

    # Fix -u may not run as fully supported user (no home, no /etc/passwd entry, etc). See entrypoint.sh
    apt-get install -y gosu && \

    # Cleanup
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

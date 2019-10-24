# chekote/ubuntu:bionic
FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    #
    # Upgrade all packages
    apt-get upgrade && \
    #
    # Fix 'debconf: delaying package configuration, since apt-utils is not installed'
    apt-get install -y apt-utils && \
    #
    # Fix -u may not run as fully supported user (no home, no /etc/passwd entry, etc). See entrypoint.sh
    apt-get install -y gosu && \
    #
    # Cleanup
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

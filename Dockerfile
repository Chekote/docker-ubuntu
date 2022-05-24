# chekote/ubuntu:latest
ARG FROM_TAG=latest

FROM ubuntu:$FROM_TAG

ENV DEBIAN_FRONTEND noninteractive

RUN set -eu; \
    #
    # Update repo data
    apt-get update; \
    #
    # Upgrade all packages
    apt-get upgrade -y; \
    #
    apt-get install -y --no-install-suggests --no-install-recommends \
      # Fix 'debconf: delaying package configuration, since apt-utils is not installed'
      apt-utils \
      #
      # Fix -u may not run as fully supported user (no home, no /etc/passwd entry, etc). See entrypoint.sh
      gosu; \
    #
    # Cleanup
    apt-get autoremove -y; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

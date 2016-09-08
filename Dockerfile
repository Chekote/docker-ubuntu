# chekote/ubuntu:yakkety
FROM ubuntu:yakkety

ENV DEBIAN_FRONTEND noninteractive

# Fix 'setlocale: LC_ALL: cannot change local (en_US.UTF-8)'
RUN locale-gen en_US.UTF-8 && \

    # Fix 'debconf: delaying package configuration, since apt-utils is not installed'
    apt-get update && \
    apt-get install -y apt-utils && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


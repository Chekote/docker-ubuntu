# chekote/ubuntu:latest
# chekote/ubuntu:$RELEASE_NAME
# chekote/ubuntu:$RELEASE_NAME-$(date +%Y-%m-%d)
ARG FROM_TAG=latest

FROM ubuntu:$FROM_TAG

ARG TARGETPLATFORM

ENV DEBIAN_FRONTEND=noninteractive

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
      gosu \
      #
      # Make sure we have the most recent Certificate Authority Certificates
      ca-certificates; \
    #
    # Cleanup
    apt-get autoremove -y; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    #
    # Mitigate CVE-2024-2961 (https://nvd.nist.gov/vuln/detail/CVE-2024-2961)
    ARCH=$(echo ${TARGETPLATFORM} | cut -d '/' -f2); \
    #
    # Determine the gnu dir based on the system architecture
    if [ "$ARCH" = "arm" ]; then \
        DIR="arm-linux-gnueabihf"; \
    elif [ "$ARCH" = "amd64" ]; then \
        DIR="x86_64-linux-gnu"; \
    elif [ "$ARCH" = "arm64" ]; then \
        DIR="aarch64-linux-gnu"; \
    else \
        echo "Unrecognized architecture '$ARCH'"; \
        exit 1; \
    fi; \
    #
    # Remove the vulnerable character sets
    sed -i -E '/CN-?EXT/d' "/usr/lib/$DIR/gconv/gconv-modules.d/gconv-modules-extra.conf";

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

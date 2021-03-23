ARG BUILD_FROM=ubuntu:latest
FROM ${BUILD_FROM}

ARG SPOTIFYD_VERSION=v0.3.2

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
RUN \
    apt-get update \
    \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cargo \
        git \
        libasound2-data \
        libasound2-dev \
        libasound2-plugins \
        libasound2 \
        libssl-dev \
        pkg-config \
        rustc \
    \
    && git clone --branch "${SPOTIFYD_VERSION}" --depth=1 \
        https://github.com/Spotifyd/spotifyd.git /tmp/spotifyd \
    \
    && cd /tmp/spotifyd \
    && cargo build --release \
    && mv /tmp/spotifyd/target/release/spotifyd /usr/bin \
    \
    && apt-get purge -y --auto-remove \
        build-essential \
        cargo \
        git \
        libasound2-dev \
        libssl-dev \
        pkg-config \
        rustc \
    \
    && rm -fr \
        /tmp/* \
        /root/.cargo \
        /var/{cache,log}/* \
        /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/spotifyd", "--no-daemon"]

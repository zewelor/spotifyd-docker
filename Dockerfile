ARG BUILD_FROM=ubuntu:22.04
FROM ${BUILD_FROM}

ARG SPOTIFYD_VERSION=v0.3.3

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
RUN apt-get update \
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
    && cargo build --release

ENTRYPOINT ["/usr/bin/spotifyd", "--no-daemon"]

FROM ${BUILD_FROM}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        dumb-init \
    && rm -fr \
        /var/{cache,log}/* \
        /var/lib/apt/lists/*

COPY --from=0 /tmp/spotifyd/target/release/spotifyd /usr/bin

ENTRYPOINT ["dumb-init", "--"]
CMD ["/usr/bin/spotifyd", "--no-daemon"]
FROM alpine:3.24

# Hugo comes from the official upstream release rather than `apk add hugo`: Alpine's
# package lags upstream and is built against older Go modules (golang.org/x/crypto,
# x/net, ...) that carry critical/high CVEs. The standard (non-extended) build is a
# static binary, so it runs on musl; talkinghealth-hugo doesn't need extended (no
# Sass or image processing). The download is verified against Hugo's checksums file.
ARG HUGO_VERSION=0.170.1
ARG TARGETARCH

RUN set -eux; \
    apk --no-cache --update upgrade; \
    apk add --no-cache rsync; \
    arch="${TARGETARCH:-amd64}"; \
    tarball="hugo_${HUGO_VERSION}_linux-${arch}.tar.gz"; \
    base="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}"; \
    cd /tmp; \
    wget -q "${base}/${tarball}" "${base}/hugo_${HUGO_VERSION}_checksums.txt"; \
    grep " ${tarball}\$" "hugo_${HUGO_VERSION}_checksums.txt" | sha256sum -c -; \
    tar -xzf "${tarball}" -C /usr/bin hugo; \
    rm -f /tmp/hugo_*; \
    hugo version

COPY crontab /etc/crontabs/root
COPY gohugo /

CMD [ "/usr/sbin/crond", "-f" ]

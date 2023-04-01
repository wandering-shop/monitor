FROM alpine:latest as builder

WORKDIR /app
COPY . ./
# This is where one could build the application code as well.


FROM alpine:latest as tailscale
WORKDIR /app
ENV TAILSCALE_VERSION=1.38.2
ENV TSFILE=tailscale_${TAILSCALE_VERSION}_amd64.tgz
RUN wget https://pkgs.tailscale.com/stable/${TSFILE} && \
  tar xzf ${TSFILE} --strip-components=1

# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM alpine:latest as blackbox
WORKDIR /extract
ENV EXPORTER_BASE=https://github.com/prometheus/blackbox_exporter/releases/download
ENV EXPORTER_VERSION=0.23.0
ENV EXPORTER_SHA=63bd4fde6984db79c95e1502a0ab47da6194d763bff22a04d1f50c4fd8322b84
ENV EXPORTER_RELEASE=${EXPORTER_BASE}/v${EXPORTER_VERSION}/blackbox_exporter-${EXPORTER_VERSION}.linux-amd64.tar.gz
ENV TARFILE=blackbox-exporter.tar.gz
RUN wget -O ${TARFILE} $EXPORTER_RELEASE
# The TWO spaces here really matter!
# See https://github.com/alpinelinux/docker-alpine/issues/246
RUN echo -e "${EXPORTER_SHA}  ${TARFILE}" | sha256sum -cw
RUN tar xf ${TARFILE}
RUN cp blackbox_exporter*/blackbox_exporter .

FROM alpine:latest
# bash is really useful for troubleshooting. The rest are required for tailscale
RUN apk update && apk add ca-certificates iptables ip6tables bash && rm -rf /var/cache/apk/*

# Copy binary to production image
COPY --from=builder /app/start.sh /app/start.sh
COPY --from=builder /app/blackbox.yml /app/blackbox.yml
COPY --from=tailscale /app/tailscaled /app/tailscaled
COPY --from=tailscale /app/tailscale /app/tailscale
COPY --from=blackbox /extract/blackbox_exporter /app/blackbox_exporter
RUN mkdir -p /var/run/tailscale /var/cache/tailscale

# mounted data
VOLUME /data

EXPOSE 9115

# Run on container startup.
CMD ["/app/start.sh"]

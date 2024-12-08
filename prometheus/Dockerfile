FROM alpine:latest AS tailscale
WORKDIR /app
ENV TAILSCALE_VERSION=1.78.1
ENV TSFILE=tailscale_${TAILSCALE_VERSION}_amd64.tgz
RUN wget https://pkgs.tailscale.com/stable/${TSFILE} && \
  tar xzf ${TSFILE} --strip-components=1

# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM prom/prometheus:v3.0.1
# RUN apk update && apk add ca-certificates iptables ip6tables prometheus && rm -rf /var/cache/apk/*

# Copy binary to production image
COPY start.sh /app/start.sh
COPY prometheus.yml /app/prometheus.yml
COPY --from=tailscale /app/tailscaled /app/tailscaled
COPY --from=tailscale /app/tailscale /app/tailscale

# mounted data
VOLUME /data
VOLUME /var/run/tailscale
VOLUME /var/cache/tailscale

# Run on container startup.
ENTRYPOINT []
CMD ["/app/start.sh"]

#!/bin/sh
set -x

hostname=${APP_HOSTNAME:-shop-monitor}

# ensure we have our data
mkdir -p /data/tailscale /data/tsdb

/app/tailscaled --state=/data/tailscale/tailscaled.state \
    --socket=/var/run/tailscale/tailscaled.sock &
/app/tailscale up --authkey="$TAILSCALE_AUTHKEY" --hostname=shop-monitor
/usr/bin/prometheus \
    --config.file=/app/prometheus.yml \
    --storage.tsdb.path=/data/tsdb \
    --storage.tsdb.retention.size=2GB \
    --web.enable-otlp-receiver

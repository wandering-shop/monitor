#!/bin/sh
set -x

hostname=${APP_HOSTNAME:-shop-monitor}

# ensure we have our data
mkdir -p /data/tailscale /data/tsdb

/app/tailscaled --state=/data/tailscale/tailscaled.state \
    --socket=/var/run/tailscale/tailscaled.sock &
/app/tailscale up --authkey="$TAILSCALE_AUTHKEY" --hostname=shop-probe
/app/blackbox_exporter \
    --config.file /app/blackbox.yml

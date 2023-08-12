# Monitoring stack for wandering.shop

## Prometheus

This runs on fly.io with strict limits about how long we keep the time series (it ends up being around 2 days of metrics).

The prometheus configuration depends on two external things:

1. statsd exporter running on all the shop nodes; this is installed via wandering-shop/server

2. tailscalesd service discovery; this is manually installed on the old wandering-shop server, in ~/monitoring. This thing's tailnet API key will die every 90 days, sadly. It'll need re-awakening

## Blackbox

This is an HTTP prober that is used by Prometheus to verify from the internet that the shop is running.

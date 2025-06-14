#!/bin/bash

# https://docs.docker.com/config/containers/multi-service_container/#use-a-wrapper-script

if [ -n "${TS_STATE}" ]; then
    echo "${TS_STATE}" | base64 -d | gzip -d > /var/lib/tailscale/tailscaled.state
fi

tailscaled --tun=userspace-networking &

if [ -z "${TS_STATE}" ]; then
    tailscale up --authkey=${TS_AUTHKEY} --hostname=${TS_HOSTNAME} --accept-dns=false
fi

blocky --config /etc/blocky/config.yml &

wait -n

exit $?

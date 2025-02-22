FROM alpine:3.21.3

RUN apk add --no-cache blocky iptables ip6tables tailscale

COPY wrapper.sh /
COPY config.yml /etc/blocky/

ENTRYPOINT ["sh", "/wrapper.sh"]

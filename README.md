# blocky-tailscale-fly

A private Tailscale ad-blocking DNS proxy container ready to be deployed to Fly.io.

## Running locally

```
docker build -t blocky-tailscale .
```

```
docker run \
        --rm \
        -e TS_AUTHKEY=tskey-auth-XXXXXXXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \
        -e TS_HOSTNAME=blocky-tailscale \
        -p 5353:53/udp \
        blocky-tailscale
```

## Deploying to Fly.io

1. Create an app.

   ```
   fly apps create blocky-tailscale
   ```

2. Set `TS_AUTHKEY`.

   ```
   fly secrets set \
        --app=blocky-tailscale \
        TS_AUTHKEY=tskey-auth-XXXXXXXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   ```

3. Set `TS_HOSTNAME` and deploy the app.

   ```
   fly deploy \
        --app=blocky-tailscale \
        --env TS_HOSTNAME=blocky-tailscale \
        --ha=false \
        --no-public-ips \
        --local-only
   ```

4. Persist the `tailscaled.state` file to `TS_STATE`.

   ```
   MACHINE_ID="$(fly machine list --app blocky-tailscale --json | jq --raw-output '.[0].id')"

   TS_STATE="$(fly console \
         --app blocky-tailscale \
         --machine=$MACHINE_ID \
         --command 'sh -c "cat /var/lib/tailscale/tailscaled.state | gzip | base64 -w 0"')"

   fly secrets set \
         --app=blocky-tailscale \
         TS_STATE=$TS_STATE
   ```

5. Finally, in Tailscale admin console, disable the key expiry for the the newly added node and add the IPv4 address as a nameserver.

## References

- https://0xerr0r.github.io/blocky/
- https://fly.io/docs/
- https://tailscale.com/kb/1282/docker

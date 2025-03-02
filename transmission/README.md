# Transmission

<https://hub.docker.com/r/linuxserver/transmission>

Connected through a VPN via the [Gluetun](https://github.com/qdm12/gluetun-wiki/blob/main/setup/connect-a-container-to-gluetun.md) container

## Install a webui

List of webuis : combustion, kettu, transmission-web-control, flood-for-transmission, shift, transmissionic

### transmission-web-control

```bash
# jq and curl are required
mkdir -p volumes/config/transmission-web-control
curl -sL $(curl -s https://api.github.com/repos/ronggang/transmission-web-control/releases/latest | jq --raw-output '.tarball_url') | tar -C ./volumes/config/transmission-web-control --strip-components=2 -xz
```

- set the env var `TRANSMISSION_WEB_HOME` to the inside path `/config/transmission-web-control`

## Test your torrent IP

- <https://www.whatismyip.net/tools/torrent-ip-checker/index.php>
- <http://checkmyip.torrentprivacy.com/>

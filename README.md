# Spotifyd Docker
![Build status](https://github.com/zewelor/spotifyd-docker/workflows/Build/badge.svg)
[![Download](https://img.shields.io/docker/pulls/zewelor/spotifyd.svg?style=for-the-badge)](https://hub.docker.com/r/zewelor/spotifyd)

Dockerized version of great [Spotifyd](https://github.com/Spotifyd/spotifyd). Setup inspired by [Hassio addon](https://github.com/hassio-addons/addon-spotify-connect) and [spotify-docker](https://github.com/joonas-fi/spotifyd-docker).

Comparing to [spotify-docker](https://github.com/joonas-fi/spotifyd-docker) it uses pure alsa, without pulseaudio.


I'm using it to use my headless server as spotify client, whole setup is dockerized thats why dockerized spotify client also.

To see available image versions check [Dockerhub](https://hub.docker.com/r/zewelor/spotifyd) page. Github action is configured to autobuild newest spotifyd version.

## How to run

### Prerequisites
In case of ubuntu/debian, ddd user to audio group. This way you can run container without root privileges (which is more secure and recommended)

```
sudo adduser <username> audio
```

After this you might need to logout and login again, to get new group working.

### Available cli options

Sample run to get available cli options

```
docker run --rm zewelor/spotifyd --help
```

### Sample run
If you don't want as user ( not recommended ), remove --user line

```
$ docker run -d \
          --name spotify \
          --device /dev/snd \
          --user "$(id -u):$(cut -d: -f3 < <(getent group audio))" \
          zewelor/spotifyd \
          --device-name Spotifyd \
          --username YOUR_USERNAME \
          --password YOUR_PASSWORD
```

## Docker Compose

Username and password kept in docker secrets.

```
secrets:
  spotify_username:
    file: /path/to/docker_secrets/spotify_username
  spotify_password:
    file: /path/to/docker_secrets/spotify_password

services:
  spotifyd:
    image: zewelor/spotifyd:latest
    container_name: spotifyd
    user: '1000:29' # Hardcoded UID and Audio GID
    devices:
      - /dev/snd:/dev/snd
    secrets:
      - spotify_username
      - spotify_password
    command: |
      --device-name Spotifyd
      --username-cmd 'cat /run/secrets/spotify_username'
      --password-cmd 'cat /run/secrets/spotify_password'
```

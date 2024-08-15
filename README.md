# scripts

A list of useful scripts to make your terminal life easy.

Tried and tested in Ubuntu & MacOS.

If you are facing any problems, you can reach out to me on zuman.one@icloud.com

## Table of Contents
- [1. Container Wrappers](#1-container-wrappers)
- [2. Home directory customization](#2-home-directory-customization)
- [3. zsync to sync files between local and server](#3-zsync-to-sync-files-between-local-and-server)
- [4. VPN Initialization script](#4-vpn-initialization-script)
- [5. Docker based Ubuntu VM](#5-docker-based-ubuntu-vm)

<br>

## 1. Container Wrappers

### 1.1. Nginx Proxy Manager
* Create a directory `nginx-proxy-manager` and copy compose.yaml to it.
* Create a `.env` file as below and run `docker compose up -d`
```
DATA=nginx-proxy-manager/data
LETSENCRYPT=nginx-proxy-manager/letsencrypt
```

### 1.2. Portainer with [reverse-proxy](https://github.com/zuman/common-proxy)
* Create a directory `portainer` and copy compose.yaml to it.
* Create a `.env` file as below and run `docker compose up -d`
```
DATA=portainer/data
PORT_443=...
PORT_8000=...
```

### 1.3. Nextcloud initialization command with [reverse-proxy](https://github.com/zuman/common-proxy)

* Setup  [Home directory customization](#1-home-directory-customization)
* Run the command: `./containers/nextcloud/nc-setup.sh`

### 1.4. Gitlab with [reverse-proxy](https://github.com/zuman/common-proxy)

* Create a directory `gitlab` and copy compose.yaml to it.
* Create a `.env` file as below.
```
HOSTNAME=...
GITLAB_HOME=...
PORT_22=...
PORT_80=...
PORT_443=...
```
* Run `docker compose up -d` and wait for it to set up.
* Copy file `containers/gitlab/gitlab.rb` to `$GITLAB_HOME/config/` directory.
* Reconfigure gitlab with command `docker exec -it gitlab gitlab-ctl reconfigure`


### 1.5. Transmission with [reverse-proxy](https://github.com/zuman/common-proxy)
* Create a directory `transmission` and copy compose.yaml to it.
* Create a `.env` file as below and run `docker compose up -d`
```
PUID=...
PGID=...
TZ=Asia/Kolkata # Your timezone
USER=...
PASS=...
CONFIG=/path/to/transmission/config
DOWNLOADS=/path/to/transmission/downloads
WATCH=/path/to/transmission/watch
```

### 1.6. Odoo with [reverse-proxy](https://github.com/zuman/common-proxy)
* Use `nginx.conf` file for nginx reverse proxy settings. Replace `odoo.example.com` with your domain name.
* Also update docker container name.
* Create a directory `odoo` and copy `compose.yaml` to it.
* In `compose.yaml`, replace `odoo-webdata` with custom webdata name.
* Create a directory `config` inside `odoo` and copy `odoo.conf` to it.
* in `odoo.conf`, uncomment `admin_passwd` and set a password.
* Create a `.env` file as below and run `docker compose up -d`
```
COMPOSE_PROJECT_NAME=your_project_name

# Port configuration
PORT_443=443

# Odoo configuration
CONFIG=/path/to/config
ADDONS=/path/to/addons

# Postgres configuration
POSTGRES_USER=your_postgres_user
POSTGRES_PASSWORD=your_postgres_password
DATA=/path/to/postgres/data

```

## 2. Home directory customization

### Commands to setup home directory.
```
./home/setup.sh
source ~/.profile
```

<br>

## 3. zsync to sync files between local and server

### Prerequisites:
    1. Complete section above : 1. Home directory customization
    2. Create a ssh profile in ~/.ssh/config file as below (Use your own details):
        Host syncserver
            Hostname server.com
            User username
            Port 22
            IdentityFile ~/.ssh/id_rsa
    
    3. Make sure the directory ~/zsync/syncdir exists and is writable at server and in local machine.


### Usage:
```
zsync [pull|push] syncserver syncdir
```

<br>

## 4. VPN Initialization script

### From home/packages.sh, copy and run the following sections:
> Setup Docker

> Net tools

### Run the following commands to initialize VPN:
```
cd vpn
./setup.sh
sudo reboot
```
### Confirm that wireguard is running:
```
cd /opt/wireguard-server
docker-compose ps
```
### Add the following ingress rules to your firewall:
![Ingress rule](images/ingress.jpg)

### Install Wireguard client on your device:
https://www.wireguard.com/install

### Show QR code for the VPN peer:
>docker exec -it wireguard /app/show-peer 1

<br>

## 5. Docker based Ubuntu VM

1. Run the below commands. (make sure to replace your username and password accordingly)

>cd vm
 
>docker build . -t vm --build-arg username=myuser --build-arg password=mypassword

2. cd into the directory where you want the home directory of the user.
2. Run the container with command
>docker run -d -v .:/home --network host --name my-vm vm

<br>

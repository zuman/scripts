# scripts

A list of useful scripts to make your terminal life easy.

Tried and tested in Ubuntu & MacOS.

If you are facing any problems, you can reach out to me on syed.zuman.007@gmail.com

## 1.  Home directory customization

### Run home/setup.sh to setup home directory.

<br><br>

## 2. zsync to sync files between local and server

### Prerequisites:
    1. Complete section above : 1. Home directory customization
    2. Create a ssh profile in ~/.ssh/config file as below (Use your own details):
        Host syncserver
            Hostname server.com
            User username
            Port 22
            IdentityFile ~/.ssh/id_rsa
    
    3. Make sure the directory ~/.zsync/syncdir exists and is writable at server and in local machine.


### Usage:
```
zsync.sh [pull|push] syncserver syncdir
```

<br><br>

## 2. Cloud VM initialization scripts

Run the following command to initialize your cloud VM based on Ubuntu distro. The parameters are:

<ol>
<li> username : The username to be create for the VM. </li>
<li> password : The password to be used for the username. </li>
<li> default_user : The default user to remove from the VM. </li>
</ol>

```
wget -O - https://raw.githubusercontent.com/zuman/scripts/master/cloud/setup.sh | sudo bash -s -- {username} {password} {default_user}
```

<br><br>

## 3.  VPN Initialization script

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

<br><br>

# scripts

A list of useful scripts to make your terminal life easy.

Tried and tested in Ubuntu & Mac.

If you are facing any problems, you can reach out to me on syed.zuman.007@gmail.com

## 1.  Home directory customization

Run home/setup.sh to setup home directory.

<br><br>

## 2. Cloud VM initialization scripts

Run the following command to initialize your cloud VM based on Ubuntu distro. The parameters are:

<ol>
<li> username : The username to be create for the VM. </li>
<li> password : The password to be used for the username. </li>
<li> default_user : The default user to remove from the VM. </li>
</ol>

> wget -O - https://raw.githubusercontent.com/zuman/scripts/master/cloud/setup.sh | sudo bash -s -- {username} {password} {default_user}

<br><br>

## 3.  VPN Initialization script

### Run the following commands to initialize VPN:
> ./home/packages.sh

> cd vpn

> ./setup.sh

### Confirm that wireguard is running:
> cd /opt/wireguard-server

> docker-compose ps

### Reboot if getting an error:
> sudo reboot

### Add the following ingress rules to your firewall:
![Ingress rule](images/ingress.jpg)

### Install Wireguard client on your device:
https://www.wireguard.com/install

### Show QR code for the VPN peer:
>docker exec -it wireguard /app/show-peer 1

<br><br>

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

apt update && apt upgrade -y
user="${1:-zap}"
password="${2:-password}"
defaultuser="${3:-ubuntu}"
echo "Hello ${user}"

echo "Enable Universal Firewall"
sed -i 's/^\[Unit\]/\[Unit\]\nAfter=netfilter-persistent.service/' /lib/systemd/system/ufw.service
echo "y" | sudo ufw enable
ufw allow ssh
systemctl restart ufw

echo "Set up $user"
useradd -m $user
chsh -s /bin/bash $user
echo "$user:$password" | chpasswd
mkdir /home/$user/.ssh
cp /home/$defaultuser/.bashrc /home/$user/.bashrc
cp /home/$defaultuser/.profile /home/$user/.profile
cp /home/$defaultuser/.ssh/authorized_keys /home/$user/.ssh/
chown -R $user:$user /home/$user
usermod -aG sudo $user
echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

echo "Remove $defaultuser from sudo group"
sed -i "/$defaultuser/d" /etc/sudoers.d/*
sed -i "/$defaultuser/d" /etc/sudoers
deluser $defaultuser sudo

echo "Setup Scripts"
su -c "mkdir /home/$user/workspace" $user
cd /home/$user/workspace
su -c 'git clone https://github.com/zuman/scripts.git' $user
cd scripts/home
su -c './setup.sh' $user

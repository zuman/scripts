# Update everything
apt update && apt upgrade -y
user="${1:-zap}"
password="${2:-password}"
defaultuser="${3:-ubuntu}"
echo "hi ${user}"

# Enable Universal Firewall
# ufw enable
# ufw allow ssh
# systemctl restart ufw

# add new user and copy ssh key
# useradd -m $user
# echo "$user:$password" | chpasswd
echo "Adding new user $user"
mkdir /home/$user/.ssh
cp /home/$defaultuser/.ssh/authorized_keys /home/$user/.ssh/


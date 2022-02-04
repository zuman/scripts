# Update everything
apt update && apt upgrade -y
user="${1:-zap}"
echo "hi ${user}"

# # Enable Universal Firewall
# ufw enable
# ufw allow ssh
# systemctl restart ufw

# add new user
useradd -m $user

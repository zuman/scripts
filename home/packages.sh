echo "Tools"
sudo apt install software-properties-common net-tools openresolv ssh vim nano sudo git curl wget nmap -y
echo "Tools complete"

echo "Setup Docker"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
echo "Setup Docker Complete"

echo "Enable Universal Firewall"
sed -i 's/^\[Unit\]/\[Unit\]\nAfter=netfilter-persistent.service/' /lib/systemd/system/ufw.service
echo "y" | sudo ufw enable
ufw allow ssh
systemctl restart ufw
echo "Enable Universal Firewall complete"

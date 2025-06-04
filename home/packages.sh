echo "Tools"
sudo apt install software-properties-common net-tools apt-utils ufw ssh vim nano sudo git curl wget nmap -y
echo "Tools complete"

echo "Setup Docker"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
echo "Setup Docker Complete"

echo "Enable Universal Firewall"
sudo sed -i 's/^\[Unit\]/\[Unit\]\nAfter=netfilter-persistent.service/' /lib/systemd/system/ufw.service
echo "y" | sudo ufw enable
sudo ufw allow ssh
sudo systemctl restart ufw
echo "Enable Universal Firewall complete"

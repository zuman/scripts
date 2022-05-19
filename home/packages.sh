echo "Setup Docker"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
echo "Setup Docker Complete"

echo "Net Tools"
sudo apt install net-tools openresolv -y
echo "Net Tools complete"

echo "Enable Universal Firewall"
sed -i 's/^\[Unit\]/\[Unit\]\nAfter=netfilter-persistent.service/' /lib/systemd/system/ufw.service
echo "y" | sudo ufw enable
ufw allow ssh
systemctl restart ufw
echo "Enable Universal Firewall complete"

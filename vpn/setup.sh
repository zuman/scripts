sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common docker-compose -y
user=$(whoami)
sudo usermod -aG docker $user
newgrp docker
sudo mkdir /opt/wireguard-server
sudo chown $user:$user /opt/wireguard-server
cp docker-compose.yaml /opt/wireguard-server/docker-compose.yaml
sed -i "/PUID/c\      - PUID=$(id -u)" /opt/wireguard-server/docker-compose.yaml
sed -i "/PGID/c\      - PGID=$(id -u)" /opt/wireguard-server/docker-compose.yaml
sudo docker-compose -f /opt/wireguard-server/docker-compose.yaml up -d

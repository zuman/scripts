echo "Setup Docker"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
groupadd docker
user=$(whoami)
sudo usermod -aG docker $user

sudo apt install net-tools openresolv -y

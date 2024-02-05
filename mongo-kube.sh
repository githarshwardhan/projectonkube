#!/bin/bash

# Check if Node.js is already installed and get the installed version (if any)
installed_version=$(node -v 2>/dev/null)

# Specify the desired Node.js version
desired_version="18.12.1"

# Compare the installed version with the desired version
if [ "$installed_version" == "v$desired_version" ]; then
  echo "Node.js v$desired_version is already installed."
else
  echo "Node.js v$desired_version is not installed. Installing..."

  # Download and install Node.js using Node Version Manager (NVM)
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
  source ~/.nvm/nvm.sh  # Load NVM into the current shell session
  source /root/.bashrc
  # Install the desired Node.js version using NVM
  nvm install "$desired_version"

  # Set the installed version as the default
  nvm use "$desired_version" --default

  # Verify the installation
  installed_version=$(node -v 2>/dev/null)
  if [ "$installed_version" == "v$desired_version" ]; then
    echo "Node.js v$desired_version has been successfully installed."
  else
    echo "Failed to install Node.js v$desired_version."
  fi
fi
#################################################
#!/bin/bash
curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/mongodb-6.gpg
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt update && sudo apt install mongodb-org docker.io -y
sudo systemctl enable --now mongod
sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/g' /etc/mongod.conf
sudo systemctl restart mongod.service
sleep 10
mongosh admin --eval "db.createUser({user:'admin',pwd:'admin123',roles:[{role:'root',db:'admin'}]})"
echo admin user created
mongosh safetyappadmindb --eval "db.createUser({user:'safetyappadmin',pwd:'safetyapp#2020',roles:[{role:'dbOwner',db:'safetyappadmindb'}]})"
echo safetyadminuser created
################################################
echo "Installing net tools packages"
apt-get install net-tools
######################################33
echo "#####Install Nginx#####"
which nginx
if [ $? -eq 1 ]
then
                echo "*****Install Nginx*****"
                apt-get install nginx -y
                systemctl start nginx
                systemctl enable nginx
                apt-get update

        else
                echo "*****Nginx is already Installed*****Skipping"
fi
##########################################
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" >> ~/kubernetes.list
sudo mv ~/kubernetes.list /etc/apt/sources.list.d
sudo apt update
sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni
sudo swapoff -a
sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{ "exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts":
{ "max-size": "100m" },
"storage-driver": "overlay2"
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl taint node `kubectl get nodes | awk '{print $1}' | sed -n 2p` node-role.kubernetes.io/control-plane:NoSchedule-

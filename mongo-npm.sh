#!/bin/bash
################
echo "Installing MongoDB in Ubuntu Host"
if [ ! -f /usr/bin/mongod ]
    then
	sudo apt-get install gnupg
        curl -fsSL https://pgp.mongodb.com/server-6.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg \
   --dearmor
       echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list 
	sudo apt-get update -y
        sudo apt-get install mongodb-org -y
        sudo systemctl start mongod.service
	sudo systemctl enable mongod
	sudo systemctl status mongod
        sleep 3
        sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/g' /etc/mongod.conf
        sudo systemctl restart mongod.service
        cat /etc/mongod.conf
        sudo systemctl status mongod.service
        sleep 10
	mongosh safetyappadmindb --eval "db.createUser({user:'safetyappadmin',pwd:'c2FmZXR5I3ZzYTIwMjMh',roles:[{role:'dbOwner',db:'safetyappadmindb'}]})"
        mongosh safetyappadmindb --eval "db.getUsers()"
else
  echo "MongoDB already installed.  Skipping..."
fi
###################"safety#vsa2023!"#################
###############Encode######"c2FmZXR5I3ZzYTIwMjMh"######################
#######################################################################
echo "*****Install nodejs on Ubuntu Host*****"
node -v
if [ $? -eq 1 ]
then
                echo "*****Install nodejs*****"
                curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
                sudo apt-get install -y nodejs
                node --version
                curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
                source /root/.bashrc
                 . ~/.nvm/nvm.sh
                nvm install v18.12.1
                nvm use v18.12.1
                node --version
        else
                echo "*****nodejs is already Installed*****Skipping"
fi
#########################
echo "Installing net tools packages"
apt-get install net-tools
#############################################
echo "#####Install Docker#####"
which docker 
if [ $? -eq 1 ]
then
                echo "*****Install Docker*****"
		sudo apt-get update 
		sudo apt-get install ca-certificates curl gnupg
		sudo install -m 0755 -d /etc/apt/keyrings
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
		sudo chmod a+r /etc/apt/keyrings/docker.gpg

		echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
		sudo apt-get update
		sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y 
		sudo systemctl start docker.service
		systemctl status docker.service
		systemctl enable docker.service
	else
		echo "*****Docker is already Installed*****Skipping"
fi
####################################################
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


#!/bin/bash 
############
folderpath=$1
GIT_Project_BRANCH=$2
###########################################################################################
#while db= read -r line; do
#        echo "$line"
#        mkdir -p /opt/deploy/$line-deployment/
#        cp -r /tmp/revamp-autmoation/deploy/project_deployment/* /opt/deploy/$line-deployment/
# 	
#	 bash +x /tmp/revamp-autmoation/projectfolder.sh
#done < projectdb
#sleep 5
###########################################################################################
echo "create the build image for project"
sleep 5
	echo "Create build directory"
        mkdir -p /opt/build/$folderpath/project/
        cp -r /tmp/revamp-autmoation/build/project/* /opt/build/$folderpath/project/
  ########Call the project build file
        bash +x /opt/build/$folderpath/project/vsa-project-image-build.sh  $folderpath $GIT_Project_BRANCH
###########################################################################################
#sleep 5
#echo "Create the DB and insert the day0 script in it and Create the project folder /mnt"
        while db= read -r line; do
        echo "$line"
#        bash +x /tmp/revamp-autmoation/prodb.sh $folderpath
#        bash +x /tmp/revamp-autmoation/projectfolder.sh $folderpath
#done < projectdb
###########################################################################################
sleep 5
#echo "push the DB name in project deployment env.sh file"
#ipaddr=$(hostname -I | awk '{print $1}')
#while project= read -r line; do
#        echo "$line"
#        sed -i "s|projectdb|$line-projectdb|g" /opt/deploy/$line-deployment/env.sh
#        sed -i "s|localhost|$ipaddr|g" /opt/deploy/$line-deployment/env.sh
#done < /tmp/revamp-autmoation/projectdb
############################################################################################
#while port= read -r portnumber; do
#	while project= read line; do
#	echo $portnumber	
#         echo $line
#	sed -i "s|4041|$portnumber|g" /opt/deploy/$line-deployment/env.sh
#done < /tmp/revamp-autmoation/port
#done < /tmp/revamp-autmoation/projectdb	
############################################################################################
#echo "Execute the deploy container file for project"
#while project= read -r line; do
#        echo "$line"
#        bash +x /opt/deploy/$line-deployment/deployqaproject1.sh
#done < /tmp/revamp-autmoation/projectdb

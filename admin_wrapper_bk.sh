#!/bin/bash 
############
folderpath=$1
GIT_MASTER_BRANCH=$2
GIT_Project_BRANCH=$3
GIT_webclient_BRANCH=$4
########################################################################################
# FUNCTION TRAP
########################################################################################
function error_trap()
{
        if [ "$?" -ne "0" ]
        then
                echo "Error !!! \"$0\" Script Failed at \"$BASH_COMMAND\" command "
        else
                echo "Success !!! \"$0\" Script executed successfully in \"$SECONDS\" seconds"
        fi

}

        trap error_trap EXIT
        set -e
###########################################################################################
##Create deploy directory
ipaddr=$(curl ifconfig.me)
mkdir -p /opt/deploy/$folderpath/admin_deployment
cp -r /tmp/revamp-autmoation/deploy/admin_deployment/.env /opt/deploy/$folderpath/admin_deployment/
cp -r /tmp/revamp-autmoation/deploy/admin_deployment/* /opt/deploy/$folderpath/admin_deployment/
sed -i "s/54.89.118.22/$ipaddr/g" /opt/deploy/$folderpath/admin_deployment/.env
#Create build directory
mkdir -p /opt/build/$folderpath/admin/
cp -r /tmp/revamp-autmoation/build/admin/* /opt/build/$folderpath/admin/

#######################Call the admin build file 

bash +x /opt/build/$folderpath/admin/vsa-admin-image-build.sh $folderpath $GIT_MASTER_BRANCH
bash +x /tmp/revamp-autmoation/adminday0insert.sh $folderpath
bash +x /tmp/revamp-autmoation/makefolder.sh 
bash +x /opt/deploy/$folderpath/admin_deployment/vsaadmindeployment.sh $folderpath
######Create Deploy directory for Project 
###########################################################################################
while db= read -r line; do
        echo "$line"
        mkdir -p /opt/deploy/$line-deployment/
	cp -r /tmp/revamp-autmoation/deploy/project_deployment/* /opt/deploy/$line-deployment/
	cp -r /tmp/revamp-autmoation/deploy/project_deployment/.projectenv /opt/deploy/$line-deployment/
	sed -i "s/54.89.118.22/$ipaddr/g" /opt/deploy/$line-deployment/.projectenv
        bash +x /tmp/revamp-autmoation/projectfolder.sh
done < project
###########################################################################################
echo "create the build image for project"
        ## Create build directory
        mkdir -p /opt/build/$folderpath/project/
        cp -r /tmp/revamp-autmoation/build/project/* /opt/build/$folderpath/project/
  ########Call the project build file
        bash +x /opt/build/$folderpath/project/vsa-project-image-build.sh  $folderpath $GIT_Project_BRANCH
###########################################################################################
echo "Create the DB and insert the day0 script in it and Create the project folder /mnt"
	while db= read -r line; do
        echo "$line"
	bash +x /tmp/revamp-autmoation/projectfolder.sh
done < project
        bash +x /tmp/revamp-autmoation/mongoproject.sh $folderpath
###########################################################################################
echo "push the DB name in project deployment env.sh file"
ipaddr=$(hostname -I | awk '{print $1}')
while project= read -r line; do
        echo "$line"
        sed -i "s|projectdb|$line-projectdb|g" /opt/deploy/$line-deployment/.projectenv
	sed -i "s|project-env-config|$line-project-env-config|g" /opt/deploy/$line-deployment/projectdeploy.sh
	sed -i "s|54.89.118.22|$ipaddr|g" /opt/deploy/$line-deployment/.projectenv
	sed -i "s|admin|$line-admin|g" /opt/deploy/$line-deployment/.projectenv
	sed -i "s|project|$line-project|g" /opt/deploy/$line-deployment/project.yml
	sed -i "s|project|$line-project|g" /opt/deploy/$line-deployment/service.yml
        sed -i "s/project-local-pv/$line-local-pv/g; s/project-local-storage/$line-project-local-storage/g" /opt/deploy/$line-deployment/pv.yml
	sed -i "s|project|$line-project|g" /opt/deploy/$line-deployment/pvc.yml
done < /tmp/revamp-autmoation/project
        bash +x /tmp/revamp-autmoation/port.sh
############################################################################################
mkdir -p /opt/static_deployment/$folderpath/
cp /tmp/revamp-autmoation/static_deployment/webclient.sh /opt/static_deployment/$folderpath/
#bash +x /opt/static_deployment/$folderpath/webclient.sh $folderpath $GIT_webclient_BRANCH

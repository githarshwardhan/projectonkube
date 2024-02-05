#!/bin/bash 
############
folderpath=$1
GIT_MASTER_BRANCH=$2
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
mkdir -p /opt/deploy/$folderpath/admin_deployment
cp -r /tmp/revamp-autmoation/deploy/admin_deployment/* /opt/deploy/$folderpath/admin_deployment/
#Create build directory
mkdir -p /opt/build/$folderpath/admin/
cp -r /tmp/revamp-autmoation/build/admin/* /opt/build/$folderpath/admin/

#######################Call the admin build file 

bash +x /opt/build/$folderpath/admin/vsa-admin-image-build.sh $folderpath $GIT_MASTER_BRANCH
#bash +x /tmp/revamp-autmoation/adminday0insert.sh $folderpath
bash +x /tmp/revamp-autmoation/makefolder.sh 
#####################################################Update the hostname 
echo "push the hostname in env file"
ipaddr=$(hostname -I | awk '{print $1}')
sleep 5 
sed -i "s|localhost|$ipaddr|g" /opt/deploy/$folderpath/admin_deployment/env.sh

#bash +x /opt/deploy/$folderpath/admin_deployment/vsaadmindeployment.sh $folderpath
############################################################################################

#!/bin/bash
#############################################################################################
#Anand : [23-March-2023] Script which pulls the code from git source, prepares artifacts
#          and builds image for application
#############################################################################################
GIT_MASTER_BRANCH=$2
folderpath=$1
GIT_TOKEN=AhaQ2ovu_4AUe8d1MQPm
#############################################################################################
# FUNCTION TRAP
#############################################################################################
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
#############################################################################################

echo $GIT_MASTER_BRANCH

#############################################################################################

        cd /opt/build/$folderpath/admin/
        rm -rf /opt/build/$folderpath/admin/vsa-revamp-admin/
        git clone https://token:AhaQ2ovu_4AUe8d1MQPm@gitlab.valueaddsofttech.com/safetyrevamp/vsa-revamp-admin.git -b $GIT_MASTER_BRANCH
        cd /opt/build/$folderpath/admin/vsa-revamp-admin/
        latest_tag=`cat version.txt`
        echo "#################### $latest_tag #########################"
        mkdir -p /opt/build/$folderpath/admin/vsa-revamp-admin/uploads/

        env
        . ~/.nvm/nvm.sh
        nvm use v18.12.1
        npm install
##############################################################################################

#Build the Docker image
        echo -e "========== Building Docker Image . . . . . !"
        cd /opt/build/$folderpath/admin/
	docker build -t $GIT_MASTER_BRANCH:$latest_tag .
        docker tag $GIT_MASTER_BRANCH:$latest_tag pratikslv38/$GIT_MASTER_BRANCH:$latest_tag
        docker push pratikslv38/$GIT_MASTER_BRANCH:$latest_tag
        docker rmi $GIT_MASTER_BRANCH:$latest_tag
##############################################################################################
# Update the environment variables to deploy latest docker image
        sed -i "s|image: pratikslv38/.*|image: pratikslv38/$GIT_MASTER_BRANCH:$latest_tag|g" /opt/deploy/$folderpath/admin_deployment/admin.yml
        echo "!!!!!!!DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

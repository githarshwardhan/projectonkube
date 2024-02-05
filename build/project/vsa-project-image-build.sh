#!/bin/bash
#############################################################################################
#Anand : [27-Dec-2022] Script which pulls the code from git source, prepares artifacts
#          and builds image for application
#############################################################################################
GIT_Project_BRANCH=$2
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

echo $GIT_Project_BRANCH

#############################################################################################
        cd /opt/build/$folderpath/project/
        rm -rf /opt/build/$folderpath/project/vsa-revamp-project/
       git clone https://token:AhaQ2ovu_4AUe8d1MQPm@gitlab.valueaddsofttech.com/safetyrevamp/vsa-revamp-project.git -b $GIT_Project_BRANCH
        cd /opt/build/$folderpath/project/vsa-revamp-project/
        latest_tag=`cat version.txt`
        echo "#################### $latest_tag #########################"
        mkdir -p /opt/build/$folderpath/project/vsa-revamp-project/uploads/project
        env
        . ~/.nvm/nvm.sh
        nvm use v18.12.1
        npm install
##############################################################################################

#Build the Docker image
        echo -e "========== Building Docker Image . . . . . !"
        cd /opt/build/$folderpath/project/
        docker build -t $GIT_Project_BRANCH:$latest_tag .
        docker tag $GIT_Project_BRANCH:$latest_tag pratikslv38/$GIT_Project_BRANCH:$latest_tag
        docker push pratikslv38/$GIT_Project_BRANCH:$latest_tag
        docker rmi $GIT_Project_BRANCH:$latest_tag
##############################################################################################
# Update the environment variables to deploy latest docker image
while project= read -r line; do
        echo "$line"
# Update the environment variables to deploy latest docker image
        sed -i "s|image: pratikslv38/.*|image: pratikslv38/$GIT_Project_BRANCH:$latest_tag|g" /opt/deploy/$line-deployment/project.yml
done < /tmp/revamp-autmoation/project

          echo "!!!!!!!DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

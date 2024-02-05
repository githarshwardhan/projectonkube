#!/bin/bash 
folderpath=$1
GIT_webclient_BRANCH=$2
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

        echo $GIT_MASTER_BRANCH
echo "###########################################################################################"
# Go to Deployment folder 

        cd /opt/static_deployment/$folderpath/
        rm -rf /opt/static_deployment/$folderpath/vsa-revamp-webclient
        git clone https://token:AhaQ2ovu_4AUe8d1MQPm@gitlab.valueaddsofttech.com/safetyrevamp/vsa-revamp-webclient.git -b $GIT_webclient_BRANCH
        cd /opt/static_deployment/$folderpath/vsa-revamp-webclient
        . ~/.nvm/nvm.sh
        nvm use v18.12.1
        npm install
echo "###########################################################################################"
sleep 10
echo "Create the Static build file"
        cd /opt/static_deployment/$folderpath/vsa-revamp-webclient
        npm run build
        ls -l /opt/static_deployment/$folderpath/vsa-revamp-webclient/build
sleep 5
# Remove the old build file from /var/www/html/safety_revamp_web_qa/
	mkdir -p /var/www/html/$folderpath/
	rm -rf /var/www/html/$folderpath/*
sleep 5
echo "###########################################################################################"

echo "Update the html file in /var/www/html/safety_revamp_web_qa/"
        cp -r /opt/static_deployment/$folderpath/vsa-revamp-webclient/build/* /var/www/html/$folderpath/
sleep 5
echo "Verify on browser"
                                

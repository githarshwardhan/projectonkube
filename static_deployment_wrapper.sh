#!/bin/bash 
folderpath=$1
GIT_webclient_BRANCH=$2
echo "##########Static Deployment##########"
mkdir -p /opt/static_deployment/$folderpath/
cp /tmp/revamp-autmoation/static_deployment/webclient.sh /opt/static_deployment/$folderpath/
bash +x /opt/static_deployment/$folderpath/webclient.sh $folderpath $GIT_webclient_BRANCH


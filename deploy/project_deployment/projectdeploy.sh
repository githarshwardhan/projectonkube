#!/bin/bash
#########################################################################
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

cd /opt/deploy/
sleep 30
sed -i "s/ip-172-31-61-124/$(kubectl get nodes | awk '{print $1}' | sed -n 2p)/g" pv.yml
kubectl create configmap project-env-config --from-env-file=.projectenv
kubectl apply -f pv.yml
kubectl apply -f pvc.yml
kubectl apply -f project.yml
kubectl apply -f service.yml

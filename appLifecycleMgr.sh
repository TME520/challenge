#! /bin/bash

echo "DERPING "$@ >> /root/.minikube/tamere
echo "Arguments are "$@
echo "Disks are"
df -h
echo "Adding user deploy"
useradd -d /deploy_home/ -m -s /bin/bash deploy
exit 0

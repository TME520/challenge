#! /bin/bash

echo "DERPING "$@ >> /root/.minikube/tamere
echo "Arguments are "$@
echo "Disks are"
df -h
echo "Adding user deploy"
useradd -d /deploy_home/ -m -s /bin/bash deploy
id deploy >> /root/.minikube/tamere
cat /root/.minikube/tamere
mkdir /deploy_home/minikube_cnf/
cp -rp /root/.minikube/* /deploy_home/minikube_cnf/
ls -lisa /deploy_home/minikube_cnf/
exit 0

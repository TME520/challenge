#! /bin/bash

echo "DERPING "$@ > /root/.minikube/tamere
echo "Arguments are "$@
echo "Disks are"
df -h
echo "Adding user deploy"
useradd -d /deploy_home/ -m -s /bin/bash deploy
id deploy >> /root/.minikube/tamere
cat /root/.minikube/tamere
echo "Creating kube config"
mkdir -p $HOME/.kube/
mv /config $HOME/.kube/
#echo "Listing pods"
#kubectl config set-cluster test-cluster --server=http://kubernetes:8443
#kubectl config use-context test-cluster
#kubectl get pods
ping -c 3 kubernetes
nc -zvvvt kubernetes 8443
exit 0

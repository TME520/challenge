#! /bin/bash

echo "DERPING "$@ > /root/.minikube/tamere
echo "Arguments are "$@
echo "Disks are"
df -h
#echo "Adding user deploy"
#useradd -d /deploy_home/ -m -s /bin/bash deploy
#id deploy >> /root/.minikube/tamere
cat /root/.minikube/tamere
echo "Copying minikube config"
mkdir /minikube_copy
cp -pr /root/.minikube/* /minikube_copy/
ls /minikube_copy/
echo "Creating kube config"
mkdir -p $HOME/.kube/
mv /config $HOME/.kube/
# sed -i -e 's/AAAAAAAA/kubernetes/g' $HOME/.kube/config
sed -i -e 's/AAAAAAAA/192.168.99.101/g' $HOME/.kube/config
cat $HOME/.kube/config
echo "Listing pods"
#kubectl config set-cluster test-cluster --server=http://kubernetes:8443
#kubectl config use-context test-cluster
kubectl get pods
echo "Pinging kub"
ping -c 3 kubernetes
nc -zvvvt kubernetes 8443
exit 0

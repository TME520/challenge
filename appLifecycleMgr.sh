#! /bin/bash

echo "DERPING "$@ > /root/.minikube/tamere
echo "Arguments are "$@
#echo "Disks are"
#df -h
#echo "Adding user deploy"
#useradd -d /deploy_home/ -m -s /bin/bash deploy
#id deploy >> /root/.minikube/tamere
#cat /root/.minikube/tamere
echo "Copying minikube config"
mkdir /minikube_copy
cp -pr /root/.minikube/* /minikube_copy/
ls /minikube_copy/
echo "Creating kube config"
mkdir -p $HOME/.kube/
mv /config $HOME/.kube/
sed -i -e 's/AAAAAAAA/kubernetes/g' $HOME/.kube/config
cat $HOME/.kube/config
#echo "Pinging kub"
#ping -c 3 kubernetes
#nc -zvvvt kubernetes 8443
echo "Deployiong the app (init)"
kubectl run hello-world --port=8080 --image=d0x2f/http-hello-world:v1.0.0 --generator=run-pod/v1
echo "Listing pods"
kubectl get pods
exit 0

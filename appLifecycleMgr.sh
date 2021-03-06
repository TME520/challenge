#! /bin/bash

function syntax() {
    # Help user figure out what he/she did wrong while invoking ALM
    echo -e "\n\e[36mApplication Lifecycle Manager\e[0m"
    echo -e "\n\e[32mSyntax:\e[0m\n\ndocker run -v ~/.minikube:/root/.minikube --add-host=kubernetes:<minikube cluster ip> <ALM image name> <init | upgrade> <Hello World image name>"
    echo -e "\n\e[32mExamples:\e[0m"
    echo "docker run -v ~/.minikube:/root/.minikube --add-host=kubernetes:192.168.99.101 ubuntubase init d0x2f/http-hello-world:v1.0.0"
    echo "docker run -v ~/.minikube:/root/.minikube --add-host=kubernetes:192.168.99.100 ubuntubase upgrade d0x2f/http-hello-world:v2.0.0"
    return 0
}

function init_env() {
    echo -e "\e[32m[INFO]\e[0m Preparing the deployment environment"
    echo -e "\e[32m[INFO]\e[0m Copying minikube config"
    mkdir /minikube_copy && cp -pr /root/.minikube/* /minikube_copy/
    if [ $? -gt 0 ] ; then
        echo -e "\e[31m[ERROR]\e[0m Failed to create minikube config. We stop here." && exit 1
    fi
    echo -e "\e[32m[INFO]\e[0m Creating kube config"
    mkdir -p $HOME/.kube/ && mv /config $HOME/.kube/ && sed -i -e 's/AAAAAAAA/kubernetes/g' $HOME/.kube/config
    if [ $? -gt 0 ] ; then
        echo -e "\e[31m[ERROR]\e[0m Failed to create kubectl config. We stop here." && exit 1
    fi
    return 0
}

function init_deployment() {
    echo -e "\e[32m[INFO]\e[0m Initial deployment for Hello World "$1
    echo -e "\e[32m[INFO]\e[0m Creating deployment YAML file"
    sed -i -e 's|BBBBBBBB|'"$1"'|g' /hello-world-deployment.yaml
    echo -e "\e[32m[INFO]\e[0m Deploying the app"
    kubectl apply -f /hello-world-deployment.yaml
    if [ $? -gt 0 ] ; then
        echo -e "\e[31m[ERROR]\e[0m Failed to create deployment. We stop here." && cleanup_the_mess && exit 1
    fi
    kubectl apply -f /hello-world-service.yaml
    if [ $? -gt 0 ] ; then
        echo -e "\e[31m[ERROR]\e[0m Failed to create service. We stop here." && cleanup_the_mess && exit 1
    fi
    kubectl autoscale deployment hello-world-deployment --min=2 --max=4 --cpu-percent=60
    if [ $? -gt 0 ] ; then
        echo -e "\e[31m[ERROR]\e[0m Failed to create autoscaler. We stop here." && cleanup_the_mess && exit 1
    fi
    sleep 3
    echo -e "\e[32m[INFO]\e[0m Listing endpoints, hpa, deploy, service and pods"
    sleep 3
    kubectl get endpoints
    kubectl get hpa
    kubectl get deploy -o wide
    kubectl get svc -o wide
    kubectl get pod -o wide
    echo -e "\e[32m[INFO]\e[0m Deployment is done. Exiting."
    return 0
}

function upgrade_deployment() {
    echo -e "\e[32m[INFO]\e[0m Upgrading deployment for Hello World"
    echo -e "\e[32m[INFO]\e[0m Upgrading to \e[36m"$1"\e[0m"
    kubectl set image deployment hello-world-deployment hello-world=$1
    if [ $? -gt 0 ] ; then
        echo -e "\e[31m[ERROR]\e[0m Failed to set a new image in order to upgrade deployment. We stop here." && exit 1
    fi
    kubectl rollout status deployment hello-world-deployment
    if [ $? -gt 0 ] ; then
        echo -e "\e[31m[ERROR]\e[0m Deployment rollout failed. We rollback, then we stop." && kubectl rollout undo deployment hello-world-deployment && exit 1
    fi
    sleep 3
    echo -e "\e[32m[INFO]\e[0m Listing endpoints, hpa, deploy, service and pods"
    sleep 3
    kubectl get endpoints
    kubectl get hpa
    kubectl get deploy -o wide
    kubectl get svc -o wide
    kubectl get pod -o wide
    echo -e "\e[32m[INFO]\e[0m Deployment is done. Exiting."
    return 0
}

function cleanup_the_mess() {
    echo -e "\e[32m[INFO]\e[0m Cleaning up..."
    kubectl delete deployment hello-world-deployment
    kubectl delete svc hello-world-service
    kubectl delete horizontalpodautoscalers.autoscaling hello-world-deployment
    return 0
}

echo -e "\e[32m[INFO]\e[0m Starting Application Lifecycle Manager"
# Safety is our number one priority
if [ $# -eq 0 ] ; then
    echo -e "\e[31m[ERROR]\e[0m No arguments provided. We stop here."
    syntax
    exit 1
elif [ $# -eq 1 ] ; then
    echo -e "\e[31m[ERROR]\e[0m Missing argument. We stop here."
    syntax
    exit 1
elif [ $# -eq 2 ] ; then
    echo -e "\e[32m[INFO]\e[0m Arguments are \e[36m"$@"\e[0m"
    case $1 in
        init) init_env
              init_deployment $2
              exit 0
              ;;
        upgrade) init_env
                 upgrade_deployment $2
                 exit 0
                 ;;
        *) echo -e "\e[31m[ERROR]\e[0m Unknown operation name. We stop here."
           syntax
           ;;
    esac
elif [ $# -gt 2 ] ; then
    echo -e "\e[31m[ERROR]\e[0m Too many arguments. We stop here."
    syntax
    exit 1
fi
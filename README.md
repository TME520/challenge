# Challenge
## Prerequisite
- You need an Internet connection
- Docker, Minikube and Kubectl must be installed
- Minikube must be running
- Minikube's metrics addon must be enabled
- The Docker image for the Application Lifecycle Management must have been built (I call it ubuntubase, feel free to pick your own name)
- Take note of Minikube's IP
```
minikube start
minikube addons enable metrics-server
docker build -t ubuntubase .
minikube ip
```
## Usage
### New deployment
- Run this command from a terminal:
```
docker run -v ~/.minikube:/root/.minikube --add-host=kubernetes:<minikube-ip> candidate-image init d0x2f/http-hello-world:v1.0.0
```
### Upgrade existing deployment
- Run this command from a terminal:
```
docker run -v ~/.minikube:/root/.minikube --add-host=kubernetes:<minikube-ip> candidate-image upgrade d0x2f/http-hello-world:v2.0.0
```
## Checks
### cURL it
- Keep note of the service's IP (the one in front of `hello-world-service`):
```
kubectl get svc
```
- Connect to the cluster and run cURL from there:
```
minikube ssh

```
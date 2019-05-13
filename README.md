# challenge

```
docker build -t ubuntubase .
docker run -v ~/.minikube:/root/.minikube --add-host=kubernetes:192.168.99.101 -it ubuntubase init
less ~/.minikube/tamere
```

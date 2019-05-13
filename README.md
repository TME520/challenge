# challenge

```
docker build -t ubuntubase .
docker run -v ~/.minikube:/root/.minikube --add-host=kubernetes:192.168.99.101 ubuntubase init d0x2f/http-hello-world:v1.0.0
docker run -v ~/.minikube:/root/.minikube --add-host=kubernetes:192.168.99.101 ubuntubase upgrade d0x2f/http-hello-world:v2.0.0
less ~/.minikube/tamere
```

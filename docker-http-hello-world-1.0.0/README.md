# Docker HTTP Hello World

Simply serves "Hello, world!" via HTTP on port 8080.

```
$ docker run -p 8080:8080 -d d0x2f/http-hello-world
$ curl localhost:8080
Hello, world.
```
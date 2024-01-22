# Simplism FaaS

## Build the image
```bash
docker build -t simplism-faas .
```

## Start the container
```bash
docker run -d -p 9000:7000 --name simplism-faas-container --rm simplism-faas
# docker run -p 9000:7000 --name simplism-faas-container --rm simplism-faas
# Simplism is listening on the 7000 http port, I map the host 9000 port of the host on the container port
```

## Push the wasm plug-in to the registry

```bash
wget https://github.com/simplism-registry/hello-world/releases/download/v0.0.1/hello-world.wasm

curl http://localhost:9000/registry/push \
-F 'file=@hello-world.wasm'

wget https://github.com/simplism-registry/small-cow/releases/download/v0.0.0/small-cow.wasm

curl http://localhost:9000/registry/push \
-F 'file=@small-cow.wasm'

wget https://github.com/simplism-registry/small-ant/releases/download/v0.0.0/small_ant.wasm

curl http://localhost:9000/registry/push \
-F 'file=@small_ant.wasm'
```

### Get the list of the published wasm files

```bash
curl http://localhost:9000/registry/discover \
-H 'content-type:text/plain; charset=UTF-8'
```


## Deploy wasm plug-ins

```bash
curl -X POST \
http://localhost:9000/spawn \
--data-binary @- << EOF
{
    "wasm-file":"./tmp/hello-world.wasm", 
    "wasm-function":"handle",
    "wasm-url": "http://localhost:7000/registry/pull/hello-world.wasm",
    "discovery-endpoint":"http://localhost:7000/discovery", 
    "service-name": "hello-world"
}
EOF
# ✋ port 7000 is internal

curl -X POST \
http://localhost:9000/spawn \
--data-binary @- << EOF
{
    "wasm-file":"./tmp/small-cow.wasm", 
    "wasm-function":"handle",
    "wasm-url": "http://localhost:7000/registry/pull/small-cow.wasm",
    "discovery-endpoint":"http://localhost:7000/discovery", 
    "service-name": "small-cow"
}
EOF

curl -X POST \
http://localhost:9000/spawn \
--data-binary @- << EOF
{
    "wasm-file":"./tmp/small_ant.wasm", 
    "wasm-function":"handle",
    "wasm-url": "http://localhost:7000/registry/pull/small_ant.wasm",
    "discovery-endpoint":"http://localhost:7000/discovery", 
    "service-name": "small_ant"
}
EOF
```

### Get the list of the running services
```bash
curl http://localhost:9000/discovery \
-H 'content-type:text/plain; charset=UTF-8'
```

> delete service by name
```bash
curl -X DELETE http://localhost:9000/spawn/name/hello-world 
```

## Call the services

```bash
curl http://localhost:9000/service/hello-world \
-H 'content-type: application/json; charset=utf-8' \
-d '{"firstName":"Bob","lastName":"Morane"}'

curl http://localhost:9000/service/small-cow \
-d '👋 Hello World 🌍'

curl http://localhost:9000/service/small_ant \
-d '✋ Hey people 🤗'
```


## Stop the FaaS
```bash
docker stop simplism-faas-container
```

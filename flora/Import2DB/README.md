## NAME

Import2DB

## TAG

1.0.0

## AUTHOR

Grupo FLORA

Daniel Doblas Jimenez
## DATE

29-09-2021 16:24

## DESCRIPTION
Upload a JSON file into MongoDB
# DOCKER

## Build

```
docker build -t enbic2lab/flora/import2db -f import2db.dockerfile .
```

## Run

```
 docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/flora/import2db --filepath "inventory.json" --username "user" --collection pruebasFlora --password "password"
```

## Submit

```
docker ... --tag 1.0.0
```


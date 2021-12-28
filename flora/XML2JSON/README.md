## NAME

XML2JSON

## TAG

1.0.0

## AUTHOR

Grupo FLORA

Daniel Doblas Jimenez
## DATE

27-09-2021 16:24

## DESCRIPTION
Process a XML file to a standar flora JSON file.
# DOCKER

## Build

```
docker build -t enbic2lab/flora/xml2json -f xml2json.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/flora/xml2json --filepath "30STF66.1.xml"
```

## Submit

```
docker ... --tag 1.0.0
```


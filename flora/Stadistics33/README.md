## NAME

STADISTICS 3_3

## TAG

1.0.0

## AUTHOR

Grupo FLORA

Daniel Doblas Jimenez
## DATE

01-10-2021 16:24

## DESCRIPTION
Proccess CSV from step 3.1
# DOCKER

## Build

```
docker build -t enbic2lab/flora/stadistics_3_3 -f stadistics33.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/flora/stadistics_3_3 --filepath "output_3_1.csv" --delimiter ";"
```

## Submit

```
docker ... --tag 1.0.0
```


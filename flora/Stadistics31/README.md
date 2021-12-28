## NAME

STADISTICS 3_1

## TAG

1.0.0

## AUTHOR

Grupo FLORA

Daniel Doblas Jimenez
## DATE

01-10-2021 16:24

## DESCRIPTION
Proccess CSV 
# DOCKER

## Build

```
docker build -t enbic2lab/flora/stadistics_3_1 -f stadistics31.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/flora/stadistics_3_1 --filepath "flora_example.csv" --delimiter ";"
```

## Submit

```
docker ... --tag 1.0.0
```


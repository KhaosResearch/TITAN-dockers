## NAME
IplotPheno

## TAG
1.0.0

## AUTHOR
Khaos Research Group

Irene Sánchez Jiménez

María Luisa Antequera Gómez

## DATE
22-07-2021 9:45

## DESCRIPTION
Graphical representation of phenological parameters

Can be interactive

## DOCKER

# Build

```
docker build -t enbic2lab/air/iplot_pheno -f IplotPheno.dockerfile .
```

# Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/air/iplot_pheno -i data/munich.csv
```

# Submit

```
docker ... --tag 1.0.0
```
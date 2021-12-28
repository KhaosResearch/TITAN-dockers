## NAME
IplotYear

## TAG
1.0.0

## AUTHOR
Khaos Research Group

Irene Sánchez Jiménez

María Luisa Antequera Gómez

Daniel Doblas Jiménez

## DATE
30-07-2021 14:00

## DESCRIPTION
Interactive graphical representation

## DOCKER

# Build

```
docker build -t enbic2lab/air/iplot_year -f IplotYear.dockerfile .
```

# Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/air/iplot_year -i data/munich.csv --pollen Alnus
```

# Submit

```
docker ... --tag 1.0.0
```
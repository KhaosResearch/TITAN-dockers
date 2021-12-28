## NAME
IplotPollen

## TAG
1.0.0

## AUTHOR
Khaos Group Research

Irene Sánchez Jiménez

María Luisa Antequera Gómez

Daniel Doblas Jiménez

## DATE
01-09-2021 15:00

## DESCRIPTION
Interactive graphical representation

## DOCKER

# Build

```
docker build -t enbic2lab/air/iplot_pollen -f IplotPollen.dockerfile .
```

# Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/air/iplot_pollen -i data/munich.csv --year 2010
```

# Submit

```
docker ... --tag 1.0.0
```
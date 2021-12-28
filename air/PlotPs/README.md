## NAME
PlotPs

## TAG
1.0.0

## AUTHOR
Khaos Research Group

Irene Sánchez Jiménez

María Luisa Antequera Gómez

## DATE
21-07-2021 12:26

## DESCRIPTION
Graphical representation

Run separately for each pollen type

## DOCKER

# Build

```
docker build -t enbic2lab/air/plot_ps -f PlotPs.dockerfile .
```

# Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/air/plot_ps -i data/munich.csv --pollenType Alnus --year 2010
```

# Submit

```
docker ... --tag 1.0.0
```
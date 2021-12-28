## NAME
PlotTrend

## TAG
1.0.0

## AUTHOR
Khaos Research Group

Irene Sánchez Jiménez

María Luisa Antequera Gómez

## DATE
19-07-2021 15:00

## DESCRIPTION
Graphical representation of trends in some main pollen season variables

Produces high number of trend plots

## DOCKER

# Build

```
docker build -t enbic2lab/air/plot_trend -f PlotTrend.dockerfile .
```

# Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/air/plot_trend -i data/munich.csv
```

# Submit

```
docker ... --tag 1.0.0
```
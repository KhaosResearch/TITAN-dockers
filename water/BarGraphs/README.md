## NAME

BarGraphs

## TAG

1.0.0

## AUTHOR

Khaos Research Group

Irene Sánchez Jiménez

## DATE

21-09-2021 14:41

## DESCRIPTION

Create the graph representing the homogeneity test introduced by command. This test indicates the breaks in the time series.

# DOCKER

## Build

```
docker build -t enbic2lab/water/bar_graphs -f BarGraphs.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/water/bar_graphs --inputData data/GALAROZA_completed.csv --inputHomogeneity data/HomogeneityTests.csv --test 'Buishand Test' --delimiterData ";" --delimiterHomogeneity ";" --dataType "Precipitation"
```

## Submit

```
docker ... --tag 1.0.0
```


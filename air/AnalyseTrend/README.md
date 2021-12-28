## NAME
AnalyseTrend

## TAG
1.0.0

## AUTHOR
Khaos Research Group

Irene Sánchez Jiménez

María Luisa Antequera Gómez

## DATE
21-07-2021 13:20

## DESCRIPTION
Graphical representation of the pollen trends

User must choose the number of the significance level

## DOCKER

# Build

```
docker build -t enbic2lab/air/analyse_trend -f AnalyseTrend.dockerfile .
```

# Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/air/analyse_trend -i data/munich.csv
```

# Submit

```
docker ... --tag 1.0.0
```
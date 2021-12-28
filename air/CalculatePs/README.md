## NAME
CalculatePs

## TAG
1.0.0

## AUTHOR
Khaos Research Group

Irene Sánchez Jiménez

María Luisa Antequera Gómez

## DATE
21-07-2021 15:00

## DESCRIPTION
Main Pollen Season calculation

Election between the different methods implemented

## DOCKER

# Build

```
docker build -t enbic2lab/air/calculate_ps -f CalculatePs.dockerfile .
```

# Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/air/calculate_ps -i data/munich.csv --method percentage 
```

# Submit

```
docker ... --tag 1.0.0
```
## NAME
QualityControl

## TAG
1.0.0

## AUTHOR
Khaos Research Group

Irene Sánchez Jiménez

María Luisa Antequera Gómez

## DATE
14-07-2021 10:57

## DESCRIPTION
Choose which pollen types are going to be analyzed

Selecting only good quality data

## DOCKER

# Build

```
docker build -t enbic2lab/air/quality_control -f QualityControl.dockerfile .
```

# Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/air/quality_control -i data/munich.csv
```

# Submit

```
docker ... --tag 1.0.0
```
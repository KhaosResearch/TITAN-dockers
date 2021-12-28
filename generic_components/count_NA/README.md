## NAME

Count NA

## TAG

1.0.0

## AUTHOR

Khaos Research Group

Irene Sánchez Jiménez

## DATE

23-11-2021 13:53

## DESCRIPTION

```
Percentage calculation of NA in the dataset.
```

# DOCKER

## Build

```
docker build -t enbic2lab/water/count_na -f CountNA.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/water/count_na --filepath "PrecipitationTimeSeries.csv" --delimiter ";"
```

## Submit

```
docker ... --tag 1.0.0
```
## NAME

Series Completion 

## TAG

1.0.0

## AUTHOR

Khaos Research Group

Irene Sánchez Jiménez

## DATE

28-09-2021 14:23

## DESCRIPTION

```
Completion of data time series using a linear regression.
```

# DOCKER

## Build

```
docker build -t enbic2lab/water/series_completion -f SeriesCompletion.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/water/series_completion --file-path "PrecipitationTimeSeries.csv" --start-date "1990-10-01" --end-date "2017-09-01" --target-station "GALAROZA" --analysis-stations "JABUGO" --analysis-stations "ARACENA" --completion-criteria "r2" --tests "snht" --delimiter ";"
```

## Submit

```
docker ... --tag 1.0.0
```
## NAME

Complete Time Series Summary 

## TAG

1.0.0

## AUTHOR

Khaos Research Group

Irene Sánchez Jiménez

## DATE

17-11-2021 13:53

## DESCRIPTION

```
Highlight only the data that have changed.
```

# DOCKER

## Build

```
docker build -t enbic2lab/water/complete_time_series_summary -f CompleteTimeSeriesSummary.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/water/complete_time_series_summary --file-path-completed "GALAROZA_completed.csv" --file-path-replaced "CompletedData.csv" --delimiter ";"
```

## Submit

```
docker ... --tag 1.0.0
```
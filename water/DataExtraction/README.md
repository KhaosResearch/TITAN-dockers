## NAME

Data Extraction

## TAG

1.0.0

## AUTHOR

Khaos Research Group

Irene Sánchez Jiménez

## DATE

24-09-2021 12:19

## DESCRIPTION

```
Extraction of statistical data for each station for each hidrologic year
```

# DOCKER

## Build

```
docker build -t enbic2lab/water/data_extraction -f DataExtraction.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/water/data_extraction --file-path "PrecipitationTimeSeries.csv" --delimiter ";"
```

## Submit

```
docker ... --tag 1.0.0
```
## NAME

CSV to HTML

## TAG

1.0.0

## AUTHOR

Grupo AGUA

Irene Sánchez Jiménez

## DATE

29-09-2021 10:19

## DESCRIPTION



# DOCKER

## Build

```
docker build -t enbic2lab/csv_to_html -f CsvToHtml.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/csv_to_html -i "data/StatisticalData_correct.csv" --delimiter ","

```

## Submit

```
docker ... --tag 1.0.0
```
## NAME
Extract from template

## TAG
1.0.0

## AUTHOR
Khaos Research Group

Daniel Doblas Jimenez

## DATE
23-09-2021 12:39

## DESCRIPTION
Extract summary from template excel file.

summary_sheet (str): Name of the xlsx sheet that includes the summay. Defaults to 'Resumen'

data_columns (str): Range of columns to include in format <initial>:<end> using excel column names. Defaults to A:AQ

## DOCKER

## Build

```
docker build -t enbic2lab/air/extract_from_template -f extractFromTemplate.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/air/extract_from_template --filepath "PlantillaMalaga.xlsx" --summary-sheet "Resumen" --data-columns "A:AQ" --code "esmala"
```

## Submit

```
docker ... --tag 1.0.0
```


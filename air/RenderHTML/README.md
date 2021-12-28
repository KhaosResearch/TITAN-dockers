## NAME

Render HTML
## TAG

1.0.0

## AUTHOR

Grupo AIRE

Daniel Doblas Jimenez
## DATE

23-09-2021 12:39

## DESCRIPTION
Generates an HTML page with a table from the pollen xlsx data

forecast (dict): Pairs of key (the same as the xlsx) and its forecasts. Example: {'Olea': 'Alza', 'Poac': 'Estable'}

station (str): Name of the data's station. Example: 'Estación ____'

title_date (str): Title message including the date. Example: 'Datos del _ al _ de _ de _ y pronóstico'

summary_sheet (str): Name of the xlsx sheet that includes the summay. Defaults to 'Resumen'

# DOCKER

## Build

```
docker build -t enbic2lab/air/render_html -f renderHtml.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/air/render_html --filepath "PlantillaMalaga.xlsx" --forecast "{'Olea': 'Alza', 'Poac': 'Estable'}" --summary-sheet "Resumen" --station "Estacion de prueba" --title-date "Datos del 1 al 31 de Diciembre de 2020 y pronóstico"

```

## Submit

```
docker ... --tag 1.0.0
```


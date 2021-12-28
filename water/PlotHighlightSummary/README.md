## NAME
PlotHighlightSummary

## TAG

1.0.0

## AUTHOR
Khaos Research Group

Adrián Segura Ortiz

## DATE

02-09-2021 15:24

## DESCRIPTION

The colored table shows the "Sum of the Year" of precipitation of each station (column)
on a specific year (row).

Blue color: Values above (Mean * 1.15)

Yellow color: Values below (Mean * 0.85)

# DOCKER

## Build

```
docker build -t enbic2lab/water/plot_highlight_summary -f PlotHighlightSummary.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/water/plot_highlight_summary -i data/StatisticalData.csv
```

## Submit

```
docker ... --tag 1.0.0
```

# TODO

* Confirmar con investigadores el valor real de los ceros (ausencia de datos o sequía)

* Preguntar rango para considerar los años máximos (azul) y mínimos (amarillo)
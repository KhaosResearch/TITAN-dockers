## NAME
Clustermap

## TAG

1.0.0

## AUTHOR

Khaos Research Group

Daniel Doblas Jiménez

## DATE
06-09-2021 17:22

## DESCRIPTION
Clustermap of precipitation and temperature values.
Columns: Stations
Rows: Years range

Values within the clustermap correspond to "Sum of the Year" (precipitation) or 
"Year Mean" (temperature).

Color scale corresponds to column variation of 
"Sum of the Year" (precipitation) or "Year Mean" (temperature).

# DOCKER

## Build

```
docker build -t enbic2lab/water/clustermap -f Clustermap.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/water/clustermap --filepath "Precipitation.csv" --delimiter ";" --date-column "Hidrologic Year" --station-column "Station" --square-column "Sum of the Year" --var-color-column "Year Collected Data (Percentage)" --palette "Spectral" --standardization "column" --nan-filter "mean"
```
NOTE: 

Two different ways:

* Precipitation: Sum of the Year's column

* Temperature: Mean Year's column

## Submit

```
docker ... --tag 1.0.0
```

## TODO
* Ask researchers about remove rows with NA data.

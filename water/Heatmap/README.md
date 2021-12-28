## NAME

Heatmap

## TAG

1.0.0

## AUTHOR

Grupo AGUA

Daniel Doblas Jiménez
## DATE

03-09-2021 12:39

## DESCRIPTION

Heatmap of precipitation and temperature values.
Columns: Stations
Rows: Years range

Values within the heatmap correspond to "Sum of the Year" (precipitation) or 
"Year Mean" (temperature).

Color scale corresponds to "Year Collected Data (Percentage)"
 
# DOCKER

## Build

```
docker build -t enbic2lab/water/heatmap -f Heatmap.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/water/heatmap --filepath "Precipitation.csv" --delimiter ";" --date-column "Hidrologic Year" --station-column "Station" --square-column "Sum of the Year" --var-color-column "Year Collected Data (Percentage)" --palette "Spectral" 
```
NOTE: 
Two different ways:
* Precipitation: Sum of the Year's column
* Temperature: Mean Year's column

## Submit

```
docker ... --tag 1.0.0
```

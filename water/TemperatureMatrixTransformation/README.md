## NAME

Temperature Matrix Transformation

## TAG

1.0.0

## AUTHOR

Khaos Research Group

Irene Sánchez Jiménez

## DATE

29-09-2021 10:00

## DESCRIPTION

```
Convert temperature data in matrix form to time series data.
```

# DOCKER

## Build

```
docker build -t enbic2lab/water/temperature_matrix_transformation -f TemperatureMatrixTransformation.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/water/temperature_matrix_transformation --file-path "AEMETTemperaturaTest.xlsx" --delimiter ";"
```

## Submit

```
docker ... --tag 1.0.0
```
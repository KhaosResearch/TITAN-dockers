## NAME
Precipitation Matrix Transformation 

## TAG
1.0.0

## AUTHOR
Khaos Research Group 

Irene Sánchez Jiménez

## DATE

28-09-2021 14:23

## DESCRIPTION

```
Convert precipitation data in matrix form to time series data.
```

# DOCKER

## Build

```
docker build -t enbic2lab/water/precipitation_matrix_transformation -f PrecipitationMatrixTransformation.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/water/precipitation_matrix_transformation --file-path "AEMETPrecipitationTest.xlsx" --delimiter ";"
```

## Submit

```
docker ... --tag 1.0.0
```
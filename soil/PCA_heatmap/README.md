# NAME

PCA_heatmap

# VERSION

1.0

# AUTHOR

Khaos Research Group

Daniel Doblas Jiménez (dandobjim@uma.es)

## DATE

23-09-2021

## DESCRIPTION
Plot the heatmap of PCA dataset.
 
# DOCKER

## Build

```shell
docker build -t enbic2lab/soil/pca_corr_heatmap -f PCACorrHeatmap.dockerfile .
```

## Run

```shell
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/soil/pca_corr_heatmap --filepath "correlation_matrix_heatmap.csv" --delimiter ","
```

# Parameters
* filepath (str) -> Name of the CSV file.
* delimiter (str) -> Delimiter of the CSV file.

# Outputs
* correlation_matrix_heatmap.pdf


# NAME

PCA_Component

# VERSION

1.0

# AUTHOR

Khaos Research Group

Daniel Doblas Jiménez (dandobjim@uma.es)

# DATE

23-09-2021

# DESCRIPTION
Create the PCA csv file.
 
# DOCKER

## Build

```
docker build -t enbic2lab/soil/pca_component -f PCAComponent.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/soil/pca_component --filepath "DataNormalized.csv" --number-components 2 --delimiter ","
```

# Parameters
* filepath (str) -> Name of the CSV file.
* number_components (int) -> Number of components desired after the dimension reduction.Default to 2.
* delimiter (str) -> Delimiter of the CSV file.

# Outputs
* correlation_matrix_heatmap.csv
* scree_plot.csv"
* PCA_plot.csv
* covariance_matrix.csv

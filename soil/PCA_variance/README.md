# NAME

PCA_variance

# VERSION

1.0

# AUTHOR

Khaos Research Group.

Daniel Doblas Jiménez (dandobjim@uma.es)

# DATE

23-09-2021

# DESCRIPTION
Create the PCA csv file.
 
# DOCKER

## Build

```shell
docker build -t enbic2lab/soil/pca_variance -f PCAVariance.dockerfile .
```

## Run

```shell
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/soil/pca_variance --filepath "DataNormalized.csv" --delimiter "," --variance-explained 75
```

# PARAMETERS
* filepath (str) -> Name of the CSV file.
* delimiter (str) -> Delimiter of the CSV file.
* variance_explained (int) -> he total variace that is want it to be explained by the Principal Components. Not needed if we set the number of components. Default to 75.


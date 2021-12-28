# NAME

PCA_variance_plot

# VERSION

1.0

# AUTHOR

Khaos Research Group

Daniel Doblas Jiménez (dandobjim@uma.es)

# DATE

23-09-2021

# DESCRIPTION
Plot the screw plot of the dataset.
 
# DOCKER

## Build

```shell
docker build -t enbic2lab/soil/pca_var_plot -f PCAVariancePlot.dockerfile .
```

## Run

```shell
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/soil/pca_var_plot pca-variance-plot.py "scree_plot.csv"
```

# PARAMETERS
* filepath (str) -> Name of the CSV file.
* delimiter (str) -> Delimiter of the CSV file.

# OUTPUTS
* scree_plot.pdf
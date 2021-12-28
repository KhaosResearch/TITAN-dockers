# NAME

PCA_scatter_plot

# VERSION

1.0

# AUTHOR

Khaos Research Group

Daniel Doblas Jiménez (dandobjim@uma.es)

# DATE

23-09-2021

# DESCRIPTION
Plot the PCA plot.

# DOCKER

## Build

```shell
docker build -t enbic2lab/soil/pca_scatter_plot -f PCAScatterPlot.dockerfile .
```

## Run

```shell
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/soil/pca_scatter_plot --filepath "PCA_plot.csv" --delimiter "," --x-axis "PC1" --y-axis "PC2" 
```

# Parameters
* filepath (str) -> Name of the CSV file.
* delimiter (str) -> Delimiter of the CSV file.
* x_axis (str) -> Name of the x axis.
* y_axis (str) -> Name of the y axis.

# Outputs
* PCA_plot.pdf


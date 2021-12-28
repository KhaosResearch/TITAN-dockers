# NAME

data_Normalization

# VERSION

1.0

# AUTHOR

Khaos Research Group

Daniel Doblas Jiménez (dandobjim@uma.es)
# DATE

29-09-2021

# DESCRIPTION
Normalized a given data, each factor have mean 0 and standard deviation 1.

# DOCKER

## Build

```
docker build -t enbic2lab/soil/data-normalization -f dataNormalization.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/soil/data-normalization --filepath "Data.csv" --delimiter ";"
```

# PARAMETERS
* filepath (str) -> Name of the CSV File.
* delimiter (str) -> Delimiter of the CSV File.

# OUTPUTS
* DataNormalized.csv
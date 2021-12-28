# NAME

SPSS2CSV

# VERSION

1.0

# AUTHOR

Khaos Research Group

Daniel Doblas Jiménez (dandobjim@uma.es)

# DATE

29-09-2021

# DESCRIPTION
Convert the SSPS file into a CSV file

# DOCKER

## Build

```shell
docker build -t enbic2lab/soil/spss2csv -f spss2csv.dockerfile .
```

## Run

```shell
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/soil/spss2csv --filepath "ExampleData.sav" --drop-index
```

# PARAMETERS
* filepath (str) -> Name of the SPSS file.
* drop_index (bol) -> Drop index of the tabular dataset

# OUTPUTS
* Data.csv
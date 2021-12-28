## NAME

LineGraphs

## TAG

1.0.0

## AUTHOR

Khaos Research Group

Irene Sánchez Jiménez

## DATE

21-09-2021 14:49

## DESCRIPTION

Calculate the accumulated average annual of the hydrological year and plot the problem station versus the base station. Plot the regression line of both stations.

# DOCKER

## Build

```
docker build -t enbic2lab/water/line_graphs -f LineGraphs.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/water/line_graphs --inputPrecipitation data/PrecipitationTimeSeries.csv --inputAnalysis  data/StationsAnalysis.csv --controlStation "GALAROZA" --baseStation "ARACENA" --delimiterPrecipitation ";" --delimiterAnalysis ";"
```

## Submit

```
docker ... --tag 1.0.0
```

\
  && R -e "install.packages('stringr', repos='http://cran.us.r-project.org')"\
  && R -e "install.packages('mvtnorm', repos='http://cran.us.r-project.org', dependencies = TRUE)" \
  && R -e "install.packages('writexl', repos='http://cran.us.r-project.org', dependencies = TRUE)" \
  && R -e "install.packages('ggvis', repos='http://cran.us.r-project.org', dependencies = TRUE)" \
  && R -e "install.packages('circular', repos='http://cran.us.r-project.org', dependencies = TRUE)" \
  && R -e "install.packages('zoo', repos='http://cran.us.r-project.org', dependencies = TRUE)"
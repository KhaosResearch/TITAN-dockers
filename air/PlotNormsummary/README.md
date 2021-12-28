## NAME
PlotNormsummary

## TAG
1.0.0

## AUTHOR
Khaos Research Group

Irene Sánchez Jiménez

María Luisa Antequera Gómez

## DATE
16-07-2021 15:00

## DESCRIPTION
Graphical representation of pollen concentrations by type and year

User must select the pollen type that will be shown

## DOCKER

# Build

```
docker build -t enbic2lab/air/plot_normsummary -f PlotNormsummary.dockerfile .
```

# Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/air/plot_normsummary -i data/munich.csv --pollen Alnus 
```

# Submit

```
docker ... --tag 1.0.0
```
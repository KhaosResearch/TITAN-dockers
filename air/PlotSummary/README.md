## NAME
PlotSummary

## TAG
1.0.0

## AUTHOR
Khaos Research Group

Irene Sánchez Jiménez

María Luisa Antequera Gómez

## DATE
19-07-2021 13:20

## DESCRIPTION
Graphical representation of average, maximun and minimun pollen concentrations by type

Usar must select the pollen type that will be shown and the moving average size (mave)

## DOCKER

# Build

```
docker build -t enbic2lab/air/plot_summary -f PlotSummary.dockerfile .
```

# Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/air/plot_summary -i data/munich.csv --pollen Alnus 
```

# Submit

```
docker ... --tag 1.0.0
```
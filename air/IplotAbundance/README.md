## NAME
IplotAbundance

## TAG
1.0.0

## AUTHOR
Khaos Research Group

Irene Sánchez Jiménez

María Luisa Antequera Gómez

## DATE
22-07-2021 12:45

## DESCRIPTION
Graphical representation of relative abundance of each pollen type

Users must choose the number of pollen types they want to plot
Can be interactive

## DOCKER

# Build

```
docker build -t enbic2lab/air/iplot_abundance -f IplotAbundance.dockerfile .
```

# Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/air/iplot_abundance -i data/munich.csv --yStart "None" --yEnd "None"
```

# Submit

```
docker ... --tag 1.0.0
```
## NAME
PollenCalendar

## TAG
1.0.0

## AUTHOR
Khaos Research Group

Irene Sánchez Jiménez

María Luisa Antequera Gómez

## DATE
22-07-2021 12:45

## DESCRIPTION
Graphical representation of the pollen calendar

User must choose the method according to their preferences

## DOCKER

# Build

```
docker build -t enbic2lab/air/pollen_calendar -f PollenCalendar.dockerfile .
```

# Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/air/pollen_calendar -i data/munich.csv --yStart "None" --yEnd "None" --classes "25, 50, 100, 300"

```

# Submit

```
docker ... --tag 1.0.0
```
## NAME

HTML2PDF

## TAG

1.0.0

## AUTHOR
Daniel Doblas Jiménez
## DATE

4-10-2021 12:39

## DESCRIPTION
Transform a html file into pdf file

# DOCKER

## Build

```
docker build -t enbic2lab/conversor/html2pdf -f Html2Pdf.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/conversor/html2pdf --filepath "heatmap.html"
```

## Submit

```
docker ... --tag 1.0.0
```


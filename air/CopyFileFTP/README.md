## NAME
CopyFileFTP

## TAG
1.0.0

## AUTHOR
Khaos Research Group 

Daniel Doblas Jimenez

## DATE
23-09-2021 12:39

## DESCRIPTION
Copy a file to FTP server

## DOCKER

## Build

```
docker build -t enbic2lab/air/copy_file_ftp -f copyFileFTP.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/air/copy_file_ftp --filepath "output.html" --user "impresora" --password "impre" --server "192.168.48.185" --port 21 --path Cris
```

## Submit

```
docker ... --tag 1.0.0
```


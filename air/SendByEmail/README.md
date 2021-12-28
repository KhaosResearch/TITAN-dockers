## NAME
SendByEmail

## TAG
1.0.0

## AUTHOR
Khaos Research Group

Daniel Doblas Jimenez

## DATE
23-09-2021 12:39

## DESCRIPTION
Sends a file to a given email adress through the SMTP

# DOCKER

## Build

```
docker build -t enbic2lab/air/send_by_email -f sendByEmail.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/air/send_by_email --filepath "Malaga.xlsx" --user "test@uma.es" --password "clearly_fake_password" --to-email "test2@uma.es" --subject "This is a test" --body """ This is a test message, lets see if it arrives"""
```

## Submit

```
docker ... --tag 1.0.0
```


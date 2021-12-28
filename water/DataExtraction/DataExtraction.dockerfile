FROM python:3.8.8

MAINTAINER Khaos Research Group <khaos.uma.es>

RUN apt-get update && apt-get install -y python3-pip

RUN pip3 install \
    pandas \
    typer

COPY . /usr/local/src/
WORKDIR /usr/local/src/

ENTRYPOINT ["python", "data_extraction.py"]
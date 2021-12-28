FROM python:3.8.8

MAINTAINER Khaos Research Group <khaos.uma.es>

RUN apt-get update && apt-get install -y python3-pip

RUN pip3 install \
    pandas \
    typer \
    openpyxl

COPY . /usr/local/src/
WORKDIR /usr/local/src/

ENTRYPOINT ["python", "temperature_matrix_transformation.py"]
FROM python:3.9.7-bullseye

MAINTAINER Khaos Research Group <khaos.uma.es>

RUN apt-get update && apt-get install -y python3-pip

RUN pip3 install \
    pandas \
    numpy \
    seaborn \
    matplotlib\
    scikit-learn \
    typer

WORKDIR /usr/local/src/
COPY . /usr/local/src/

ENTRYPOINT ["python", "clustermap.py"]
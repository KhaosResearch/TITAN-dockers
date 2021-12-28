FROM r-base:4.1.0

MAINTAINER Khaos Research Group <khaos.uma.es>

RUN apt-get update && apt-get install -y \
   curl \
   libssl-dev \
   libcurl4-openssl-dev \
   libxml2-dev

RUN R -e "install.packages('optparse', repos='http://cran.us.r-project.org', dependencies = TRUE)" \
  && R -e "install.packages('AeRobiology', repos='http://cran.us.r-project.org', dependencies = TRUE)" \
   && R -e "install.packages('tidyverse', repos='http://cran.us.r-project.org', dependencies = TRUE)" 

COPY . /usr/local/src/
WORKDIR /usr/local/src/

ENTRYPOINT ["Rscript", "--vanilla", "wf6_air_STEP18.R"]
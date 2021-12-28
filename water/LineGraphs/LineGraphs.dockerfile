FROM r-base:4.1.0

MAINTAINER Khaos Research Group <khaos.uma.es>

RUN apt-get update && apt-get install -y \
   curl \
   libssl-dev \
   libcurl4-openssl-dev \
   libxml2-dev \
   libfontconfig1-dev \
   pandoc

RUN R -e "install.packages('plotly', repos='http://cran.us.r-project.org')" \
  && R -e "install.packages('optparse', repos='http://cran.us.r-project.org')"\
  && R -e "install.packages('htmlwidgets', repos='http://cran.us.r-project.org')"\
  && R -e "install.packages('dplyr', repos='http://cran.us.r-project.org')"\
  && R -e "install.packages('stringr', repos='http://cran.us.r-project.org')"

COPY . /usr/local/src/
WORKDIR /usr/local/src/

ENTRYPOINT ["Rscript", "--vanilla", "line_graphs.R"]
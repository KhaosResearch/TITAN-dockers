FROM r-base:4.1.0

MAINTAINER Khaos Research Group <khaos.uma.es>

RUN apt-get update && apt-get install -y \
   curl \
   libssl-dev \
   libcurl4-openssl-dev \
   libxml2-dev \
   libfontconfig1-dev \
   pandoc

RUN R -e "install.packages('optparse', repos='http://cran.us.r-project.org', dependencies = TRUE)" \
   && R -e "install.packages('plotly', repos='http://cran.us.r-project.org', dependencies = TRUE)" \
   && R -e "install.packages('htmlwidgets', repos='http://cran.us.r-project.org', dependencies = TRUE)" \
   && R -e "install.packages('tidyverse', repos='http://cran.us.r-project.org', dependencies = TRUE)" \
   && R -e "install.packages('mvtnorm', repos='http://cran.us.r-project.org', dependencies = TRUE)" \
   && R -e "install.packages('writexl', repos='http://cran.us.r-project.org', dependencies = TRUE)" \
   && R -e "install.packages('ggvis', repos='http://cran.us.r-project.org', dependencies = TRUE)" \
   && R -e "install.packages('circular', repos='http://cran.us.r-project.org', dependencies = TRUE)" \
   && R -e "install.packages('zoo', repos='http://cran.us.r-project.org', dependencies = TRUE)"

COPY . /usr/local/src/
WORKDIR /usr/local/src/

ENTRYPOINT ["Rscript", "--vanilla", "wf6_air_STEP9_year.R"]
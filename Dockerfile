FROM r-base:latest

MAINTAINER Winston Chang "winston@rstudio.com"

RUN apt-get update && apt-get install -y -t unstable \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev

RUN apt-get -y install libxml2-dev libssl-dev

## Install some external dependencies. 
RUN apt-get update \
  && apt-get install -y --no-install-recommends -t unstable \
    default-jdk \
    default-jre \
    gdal-bin \
    icedtea-netx \
    libatlas-base-dev \
    libcairo2-dev \
    libhunspell-dev \
    libgsl0-dev \
    libgdal-dev \
    libgeos-dev \
    libgeos-c1v5 \
    librdf0-dev \
    libssl-dev \
    libmysqlclient-dev \
    libpq-dev \
    libsqlite3-dev \
    librsvg2-dev \
    libv8-dev \
    libxcb1-dev \
    libxdmcp-dev \
    libxml2-dev \
    libxslt1-dev \
    libxt-dev \
    mdbtools \
    netcdf-bin \
    qpdf \
    r-cran-rgl \
    ssh \
    vim \
  && R CMD javareconf \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# Download and install shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    R -e "install.packages(c('shiny', 'rmarkdown', 'ggvis', 'data.table', 'shinydashboard', 'flexdashboard', 'devtools', 'RCurl', 'readxl', 'plotly', 'DT'), repos='https://cran.rstudio.com/')" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/

RUN R -e "devtools::install_github('cscheid/rgithub')"
RUN R -e "devtools::install_github('raubreywhite/RAWmisc')"

RUN R -e "install.packages(c('ineq'), repos='https://cran.rstudio.com/')" 

EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

CMD ["/usr/bin/shiny-server.sh"]

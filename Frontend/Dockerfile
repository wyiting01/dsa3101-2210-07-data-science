FROM rocker/shiny:4.0.5

# system libraries
# Try to only install system libraries you actually need
# Package Manager is a good resource to help discover system deps
RUN apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libssl-dev
  

# install R packages required 
# Change the packages list to suit your needs
RUN R -e "install.packages(c('jsonlite','shiny','shiny.router','shinydashboard','shinyWidgets','png','flexdashboard','dplyr','stringr','png','shinyjs','DT','visNetwork','rintrojs','httr','RJSONIO'))"


# copy the app directory into the image
COPY ./app/* /srv/shiny-server/

# run app
CMD ["/usr/bin/shiny-server"]





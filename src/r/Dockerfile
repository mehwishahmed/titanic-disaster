# 22: Dockerfile for R version

# start from an image that already has R 4.4.1
FROM rocker/r-ver:4.4.1

# folder inside the container
WORKDIR /app

# install the packages
COPY install_packages.R .
RUN Rscript install_packages.R

# copy in the script
COPY titanic.R .

# run the script
CMD ["Rscript", "titanic.R"]
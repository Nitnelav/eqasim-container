# Use an official Ubuntu as a parent image
FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

ARG env_path

# Install dependencies
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    maven \
    python3 \
    python3-pip \
    wget \
    unzip \
    git \
    && apt-get clean

# Install Miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

# Set path to conda
ENV PATH /opt/conda/bin:$PATH

# Install Osmosis
RUN wget --quiet https://github.com/openstreetmap/osmosis/releases/download/0.48.3/osmosis-0.48.3.zip -O /tmp/osmosis.zip && \
    unzip /tmp/osmosis.zip -d /opt/osmosis && \
    rm /tmp/osmosis.zip && \
    ln -s /opt/osmosis/bin/osmosis /usr/local/bin/osmosis

# Verify installations
RUN java -version && \
    mvn -version && \
    python3 --version && \
    conda --version && \
    which osmosis

# Copy the environment.yml file into the container if env_path is set (else will create an empty directory)
COPY ${env_path} /tmp/environment.yml.tmp

# Check if env_path is set, if not download from the git repo
RUN if [ -z "$env_path" ]; then \
    wget --quiet https://raw.githubusercontent.com/eqasim-org/ile-de-france/refs/heads/develop/environment.yml -O /tmp/environment.yml; \
    else \
    mv /tmp/environment.yml.tmp /tmp/environment.yml; \
    fi

# Create the conda environment
RUN conda env create -f /tmp/environment.yml -n eqasim

# Activate the environment
RUN echo "source activate eqasim" > ~/.bashrc

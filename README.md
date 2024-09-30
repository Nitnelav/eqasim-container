# eqasim-container
Containers for running the Eqasim pipeline

## Docker container

To build the container :
`docker build . -t eqasim`

To run the pipeline : 
`docker run --rm -it eqasim /bin/bash -l -c "python -m synpp"`

## Apptainer 

To build the container : 
`apptainer -v -d build eqasim.sif apptainer.def`

To run the pipeline : 
`apptainer run eqasim.sif`

# colomoto-docker

## Run the docker image

    $ docker pull colomoto/colomoto-docker

    $ docker run -it --rm -p 8888:8888 colomoto/colomoto-docker

Then go to http://localhost:8888 for the jupyter notebook web interface.

## Compile the docker image

The image is automatically built on pushes. If you want to built it locally, use the following command:

    $ docker build -t colomoto/colomoto-docker .

## Use cases

### Use case 1 : stable states and model checking

The first described use case corresponds to the following steps:
* Find the stable states of a GINsim model,
* Export the model in NuSMV format,
* Add properties to be checked to the exported file,
* Use NuSMV to check if the model satisfies the properties,
* Create a simplified report of NuSMV results.

Once you have installed SnakeMake (https://snakemake.readthedocs.io/), open a terminal inside the 'colomoto-docker' folder and run:

    $ snakemake --reason --snakefile ./SnakeMake/Snakefile_GINsim-SS_NuSMV

A new output folder will be created, containing the results.

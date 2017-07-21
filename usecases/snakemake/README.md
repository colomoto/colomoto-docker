# colomoto-docker: SnakeMake use cases

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

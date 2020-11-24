# The CoLoMoTo Docker

 <a title="Docker Hub" href="https://hub.docker.com/r/colomoto/colomoto-docker"><img src="https://img.shields.io/docker/pulls/colomoto/colomoto-docker.svg?longCache=true&style=flat-square&logo=docker&logoColor=fff"></a>
[![PyPI version](https://badge.fury.io/py/colomoto-docker.svg)](https://badge.fury.io/py/colomoto-docker)
[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/colomoto/colomoto-docker/mybinder/latest)
[![Gitter](https://badges.gitter.im/colomoto/colomoto-docker.svg)](https://gitter.im/colomoto/colomoto-docker?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

## Quick usage guide

You need [Docker](https://docs.docker.com/get-docker/).
We support GNU/Linux, macOS, and Windows.

### Using the colomoto-docker script

You need [Python](http://python.org).

The script can be installed and upgraded by executing the following command
(you may have to use `pip3` instead of `pip` depending on your configuration):

    pip install -U colomoto-docker


The CoLoMoTo notebook can then be started by executing in a terminal (if using Docker Toolbox, in a Docker Terminal):

    colomoto-docker

The container can be stopped by pressing <kbd>Ctrl</kbd>+<kbd>C</kbd> keys.

By default, the script uses the most recently fetched image; the first time, it fetches the most recent [colomoto/colomoto-docker tag](https://github.com/colomoto/colomoto-docker/releases).
A specific tag can be specified using the `-V` option. For example:

    colomoto-docker                 # uses the most recently fetched image
    colomoto-docker -V latest       # fetches the latest published image
    colomoto-docker -V 2018-05-29   # fetches a specific image

**Warning**: by default, the files within the Docker container are isolated from the running host computer, therefore *files are deleted after stopping the container*, except the files within the `persistent` directory.

To have access to the files of your current directory you can use the `--bind` option:

    colomoto-docker --bind .

If you want to have the tutorial notebooks alongside your local files, you can
do the following:

    mkdir notebooks
    colomoto-docker -v notebooks:local-notebooks

in the Jupyter browser, you will see a `local-notebooks` directory which is
bound to your `notebooks` directory.

See

    colomoto-docker --help

for other options.


### Manual invocation

First fetch the image with

    docker pull colomoto/colomoto-docker:TAG

where `TAG` is the version of the image, among [colomoto/colomoto-docker tags](https://github.com/colomoto/colomoto-docker/releases).

The image can be ran using

    docker run -it --rm -p 8888:8888 colomoto/colomoto-docker:TAG

then, open your browser and go to http://localhost:8888 for the Jupyter notebook web interface
(note: when using Docker Toolbox, replace localhost with the result of
`docker-machine ip default` command).


## Embedded software

Besides the [Jupyter notebook](http://jupyter.org), the docker image provides
access to the following softwares:

| Software tool | Homepage | Description | Jupyter interface |
| --- | --- | --- | --- |
| ActoNet | https://github.com/algorecell/pyActoNet | Abduction-based control of fixed points of Boolean networks  | Python module [`actonet`](https://github.com/algorecell/pyActoNet) |
| bioLQM | http://colomoto.org/biolqm/ | Logical Qualitative Modelling toolkit | Python module [`biolqm`](https://github.com/GINsim/GINsim-python) |
| BooleanNet | https://github.com/ialbert/booleannet | Simulation of Boolean regulatory networks | Python module [`boolean2`](https://github.com/ialbert/booleannet) |
| boolSim | https://www.vital-it.ch/research/software/boolSim | Attractors and reachable sets in synchronous and asynchronous Boolean networks | Python module [`boolsim`](https://github.com/colomoto/boolSim-python) |
| CABEAN | https://satoss.uni.lu/software/CABEAN/ | A Software Tool for the Control of Asynchronous Boolean Networks | Python module [`cabean`](https://github.com/algorecell/cabean-python) |
| Caspo | https://bioasp.github.io/caspo/ | Reasoning on the response of logical signaling networks with Answer Set Programming | Python module [`caspo_control`](https://github.com/algorecell/caspo-control) |
| CaSQ | https://github.com/soli/casq | Convert static interaction maps into executable models | Python module [`casq`](https://github.com/soli/casq) |
| CellCollective | https://cellcollective.org | Model repository and knowledge base | Python module [`cellcollective`](https://github.com/colomoto/colomoto-jupyter) |
| GINsim | http://ginsim.org | Boolean and multi-valued network modelling | Python module [`ginsim`](https://github.com/GINsim/GINsim-python) |
| MaBoSS | http://maboss.curie.fr | Markovian Boolean Stochastic Simulator | Python module [`maboss`](https://github.com/colomoto/pyMaBoSS) |
| mpbn | https://github.com/pauleve/mpbn | Most Permissive Boolean Networks | Python module [`mpbn`](https://github.com/pauleve/mpbn) |
| NuSMV | http://nusmv.fbk.eu | Symbolic model-checker | Python module [`nusmv`](https://github.com/colomoto/colomoto-jupyter)
| Pint | https://loicpauleve.name/pint | Static analyzer for dynamics of Automata Networks | Python module [`pypint`](https://github.com/pauleve/pint)  |
| PyBoolNet | https://github.com/hklarner/PyBoolNet | Generation, modification and analysis of Boolean networks | Python module [`PyBoolNet`](https://github.com/hklarner/PyBoolNet)  |
| R-BoolNet | https://cran.r-project.org/package=BoolNet | Analysis and reconstruction of Boolean networks dynamics | RPY2 python interface |
| StableMotifs | https://github.com/jgtz/StableMotifs | Target-control of Boolean networks | Python module [`stablemotifs`](https://github.com/algorecell/StableMotifs-python) |



## Tagging policy and re-executability considerations

Docker images are timestamped with tags of the form YYYY-MM-DD after each tool addition or upgrade.

In order to guarantee the re-executability of your notebook, we recommend to use these tagged images instead of the non-persistent `next` tag.

## Contribute

See [CONTRIBUTING.md](CONTRIBUTING.md).


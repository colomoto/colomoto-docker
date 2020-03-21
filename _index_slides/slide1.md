---
---

The CoLoMoTo Interactive Notebook relies on *Docker* and *Jupyter*
technologies to provide a **unified environment** to edit, execute, share,
and reproduce analyses of **qualitative models of biological networks**.

## Quick usage guide

You need [Docker](http://docker.com) and [Python](http://python.org).
We support GNU/Linux, macOS, and Windows.

    sudo pip install -U colomoto-docker   # only once; you may have to use pip3
    colomoto-docker

The container can be stopped by pressing <kbd>Ctrl</kbd>+<kbd>C</kbd> keys.

By default, the script will fetch the most recent [colomoto/colomoto-docker tag](https://hub.docker.com/r/colomoto/colomoto-docker/tags?ordering=last_updated). A specific tag can be specified using the `-V` option; or use `-V same` to use the most recently fetched image. For example:

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

Having issues? have a look at our [Troubleshooting](https://github.com/colomoto/colomoto-docker/blob/master/TROUBLESHOOTING.md) page, or [open an issue](https://github.com/colomoto/colomoto-docker/issues).

## Available software tools with Python API

* [bioLQM](http://colomoto.org/biolqm/) -- Logical Qualitative Modelling toolkit<br/>
  Python module [`biolqm`](https://github.com/GINsim/GINsim-python)
* [CellCollective](https://cellcollective.org) -- Model repository and knowledge base<br/>
  Python module [`cellcollective`](https://github.com/colomoto/colomoto-jupyter)
* [GINsim](http://ginsim.org) -- Boolean and multi-valued network modelling<br/>
  Python module [`ginsim`](https://github.com/GINsim/GINsim-python) 
* [MaBoSS](http://maboss.curie.fr) -- Markovian Boolean Stochastic Simulator<br/>
  Python module [`maboss`](https://github.com/colomoto/pyMaBoSS)
* [mpbn](https://github.com/pauleve/mpbn) -- Most Permissive Boolean Networks<br/>
  Python module [`mpbn`](https://github.com/pauleve/mpbn)
* [NuSMV](http://nusmv.fbk.eu) -- Symbolic model-checker<br/>
  Python module [`nusmv`](https://github.com/colomoto/colomoto-jupyter)
* [Pint](https://loicpauleve.name/pint) -- Static analyzer for dynamics of Automata Networks<br/>
  Python module [`pypint`](https://github.com/pauleve/pint)
* [R-BoolNet](https://cran.r-project.org/package=BoolNet) -- Analysis and reconstruction of Boolean networks dynamics<br/>
  Generic RPY2 python interface

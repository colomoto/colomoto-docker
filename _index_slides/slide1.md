---
---

The CoLoMoTo Interactive Notebook relies on *Docker* and *Jupyter*
technologies to provide a **unified environment** to edit, execute, share,
and reproduce analyses of **qualitative models of biological networks**.

## Quick usage guide

### Without any installation

Visit [mybinder.org/v2/gh/colomoto/colomoto-docker/mybinder/latest](https://mybinder.org/v2/gh/colomoto/colomoto-docker/mybinder/latest) to launch the most recent CoLoMoTo Notebook environment without any installation thanks to [Binder](https://mybinder.org) services. You can replace `latest` with a specific [image tag](https://github.com/colomoto/colomoto-docker/releases).

Note that the computing resources are limited and the storage is not persistent.

### With Python Helper Script

You need [Docker](https://docs.docker.com/get-docker/) and [Python](http://python.org).
We support GNU/Linux, macOS, and Windows.

    sudo pip install -U colomoto-docker   # only once; you may have to use pip3
    colomoto-docker

The container can be stopped by pressing <kbd>Ctrl</kbd>+<kbd>C</kbd> keys.

By default, the script will fetch the most recent [colomoto/colomoto-docker tag](https://github.com/colomoto/colomoto-docker/releases). A specific tag can be specified using the `-V` option; or use `-V same` to use the most recently fetched image. For example:

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

### Python-less usage

You need [Docker](https://docs.docker.com/get-docker/).

First, pick an image version among [colomoto/colomoto-docker tags](https://github.com/colomoto/colomoto-docker/releases).
Fetch the image with

    docker pull colomoto/colomoto-docker:TAG

The image can be ran using

    docker run -it --rm -p 8888:8888 colomoto/colomoto-docker:TAG

then, open your browser and go to http://localhost:8888 for the Jupyter notebook web interface
(note: when using Docker Toolbox, replace localhost with the result of
`docker-machine ip default` command).

## Available software tools with Python API

* [ActoNet](https://github.com/algorecell/pyActoNet) -- Abduction-based control of fixed points of Boolean networks<br/>
  Python module [`actonet`](https://github.com/algorecell/pyActoNet)
* [AEON.py](https://github.com/sybila/biodivine-aeon-py) -- Symbolic analysis (attractors, reachability) of (partially specified) Boolean networks<br>
  Python module [`biodivine_aeon`](https://github.com/sybila/biodivine-aeon-py)
* [bioLQM](http://colomoto.org/biolqm/) -- Logical Qualitative Modelling toolkit<br/>
  Python module [`biolqm`](https://github.com/GINsim/GINsim-python)
* [BNS](https://people.kth.se/~dubrova/BNS/user_manual.html) -- Identification of synchronous attractors<br>
  Python module [`bns`](https://github.com/colomoto/bns-python)
* [BooleanNet](https://github.com/ialbert/booleannet) -- Simulation of Boolean regulatory networks<br>
  Python module [`boolean2`](https://github.com/ialbert/booleannet)
* [boolSim](https://www.vital-it.ch/research/software/boolSim) -- Attractors and reachable sets in synchronous and asynchronous Boolean networks<br>
  Python module [`boolsim`](https://github.com/colomoto/boolSim-python)
* [CABEAN](https://satoss.uni.lu/software/CABEAN/) -- A Software Tool for the Control of Asynchronous Boolean Networks<br/>
  Python module [`cabean`](https://github.com/algorecell/cabean-python)
* [Caspo](https://bioasp.github.io/caspo/) -- Reasoning on the response of logical signaling networks with Answer Set Programming<br/>
  Python module [`caspo`](https://bioasp.github.io/caspo/) and [`caspo_control`](https://github.com/algorecell/caspo-control)
* [CaSQ](https://github.com/soli/casq) -- Convert static interaction maps into executable models<br/>
  Python module [`casq`](https://github.com/soli/casq)
* [CellCollective](https://cellcollective.org) -- Model repository and knowledge base<br/>
  Python module [`cellcollective`](https://github.com/colomoto/colomoto-jupyter)
* [GINsim](http://ginsim.org) -- Boolean and multi-valued network modelling<br/>
  Python module [`ginsim`](https://github.com/GINsim/GINsim-python)
* [MaBoSS](http://maboss.curie.fr) -- Markovian Boolean Stochastic Simulator<br/>
  Python module [`maboss`](https://github.com/colomoto/pyMaBoSS)
* [mpbn](https://github.com/pauleve/mpbn) -- Most Permissive Boolean Networks<br/>
  Python module [`mpbn`](https://github.com/pauleve/mpbn)
* [NORDic](https://github.com/clreda/NORDic) -- Network Oriented Repurposing of Drugs<br>
  Python module [`NORDic`](https://github.com/clreda/NORDic)
* [NuSMV](http://nusmv.fbk.eu) -- Symbolic model-checker<br/>
  Python module [`nusmv`](https://github.com/colomoto/colomoto-jupyter)
* [Pint](https://loicpauleve.name/pint) -- Static analyzer for dynamics of Automata Networks<br/>
  Python module [`pypint`](https://github.com/pauleve/pypint)
* [PyBoolNet](https://github.com/hklarner/PyBoolNet) -- Generation, modification and analysis of Boolean networks<br>
  Python module [`PyBoolNet`](https://github.com/hklarner/PyBoolNet)
* [R-BoolNet](https://cran.r-project.org/package=BoolNet) -- Analysis and reconstruction of Boolean networks dynamics<br/>
  Generic RPY2 python interface
* [scBoolSeq](https://github.com/bnediction/scBoolSeq) -- scRNA-Seq data binarisation and synthetic generation from Boolean dynamics<br>
  Python module [`scboolseq`](https://github.com/bnediction/scBoolSeq)
* [pyStableMotifs](https://github.com/jcrozum/pystablemotifs) -- Target-control of Boolean networks<br/>
  Python module [`pystablemotifs`](https://github.com/jcrozum/pystablemotifs)

# The CoLoMoTo Docker and Notebook

 <a title="Docker Hub" href="https://hub.docker.com/r/colomoto/colomoto-docker"><img src="https://img.shields.io/docker/pulls/colomoto/colomoto-docker.svg?longCache=true&style=flat-square&logo=docker&logoColor=fff"></a>
[![PyPI version](https://badge.fury.io/py/colomoto-docker.svg)](https://badge.fury.io/py/colomoto-docker)
[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/colomoto/colomoto-docker/mybinder/latest)
[![Gitter](https://badges.gitter.im/colomoto/colomoto-docker.svg)](https://matrix.to/#/#colomoto_community:gitter.im)
[![DOI:10.3389/fphys.2018.00680](https://img.shields.io/badge/DOI-10.3389/fphys.2018.00680-blue.svg)](https://doi.org/10.3389/fphys.2018.00680)


The CoLoMoTo Interactive Notebook relies on *Docker* and *Jupyter* technologies to provide a **unified environment** to edit, execute, share, and reproduce analyses of **qualitative models of biological networks**.

## Quick usage guide

You need [Docker](https://docs.docker.com/get-docker/) and [Python](http://python.org).
We support GNU/Linux, macOS, and Windows.

Install the helper script in a terminal:

    pip install -U colomoto-docker    # or python3 -m pip install ..

The CoLoMoTo notebook can be started by executing in a terminal (if using Docker Toolbox, in a Docker Terminal):

    colomoto-docker

The container can be stopped by pressing <kbd>Ctrl</kbd>+<kbd>C</kbd> keys.

A specific tag can be specified using the `-V` option. For example:

    colomoto-docker -V latest       # fetches the latest published image
    colomoto-docker -V 2024-04-01   # fetches a specific image

**Warning**: by default, the files within the Docker container are isolated from the running host computer, therefore *files are deleted after stopping the container*, except the files within the `persistent` directory.

To have access to the files of your current directory you can use the `--bind` option:

    colomoto-docker --bind .

See [usage guide](docs/usage.md) for further options and alternative methods.

## Contribute

See how to [add your tool](CONTRIBUTING.md).

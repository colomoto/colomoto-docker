# colomoto-docker

[![](https://images.microbadger.com/badges/image/colomoto/colomoto-docker.svg)](http://microbadger.com/images/colomoto/colomoto-docker "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/colomoto/colomoto-docker.svg)](https://microbadger.com/images/colomoto/colomoto-docker "Get your own version badge on microbadger.com")

## Quick usage guide

You need [Docker](http://docker.com).
We support GNU/Linux, macOS, and Windows.

### Using the colomoto-docker script

You need [Python](http://python.org).

The script can be installed and upgraded by executing the following command:

    pip install -U colomoto-docker
    
The CoLoMoTo notebook can then be started by executing in a terminal (if using Docker Toolbox, in a Docker Terminal):

    colomoto-docker

The container can be stopped by pressing <kbd>Ctrl</kbd>+<kbd>C</kbd> keys.

By default, the script will fetch the most recent [colomoto/colomoto-docker tag](https://hub.docker.com/r/colomoto/colomoto-docker/tags/). A specific tag can be specified using the `-V` option. For example:

    colomoto-docker -V 2018-02-01

**Warning**: by default, the files within the Docker container are isolated from the running host computer, therefore *files are deleted after stopping the container*.
To have access to the files of your current directory you should use the `--bind` option:

    colomoto-docker --bind .
      
See

    colomoto-docker --help

for other options.


### Manual invocation

First fetch the image with

    docker pull colomoto/colomoto-docker:TAG

where `TAG` is the version of the image, among [colomoto/colomoto-docker tags](https://hub.docker.com/r/colomoto/colomoto-docker/tags/).

The image can be ran using

    docker run -it --rm -p 8888:8888 colomoto/colomoto-docker:TAG

then, open your browser and go to http://localhost:8888 for the Jupyter notebook web interface
(note: when using Docker Toolbox, replace localhost with the result of
`docker-machine ip default` command).


## Embedded softwares

Besides the [Jupyter notebook](http://jupyter.org), the docker image provides
access to the following softwares:

* [GINsim](http://ginsim.org)
* [MaBoSS](https://maboss.curie.fr)
* [NuSMV](http://nusmv.fbk.eu)
* [Pint](http://loicpauleve.name/pint)


## Tagging policy and re-executability considerations

Docker images are timestamped with tags of the form YYYY-MM-DD after each tool addition or upgrade.

In order to guarantee the re-executability of your notebook, we recommend to use these tagged images instead of the non-persistent `next` tag.

## Contribute

See [CONTRIBUTING.md](CONTRIBUTING.md).


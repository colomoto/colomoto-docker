# colomoto-docker

[![](https://images.microbadger.com/badges/image/colomoto/colomoto-docker:latest.svg)](http://microbadger.com/images/colomoto/colomoto-docker:latest "Get your own image badge on microbadger.com")

## Quick usage guide

You need [Docker](http://docker.com).
First fetch the image with

    $ docker pull colomoto/colomoto-docker:TAG

where `TAG` is the version of the image, among [colomoto/colomoto-docker tags](https://hub.docker.com/r/colomoto/colomoto-docker/tags/).
It can be omited when using `latest` version.

The image can be ran using

    $ docker run -it --rm -p 8888:8888 colomoto/colomoto-docker:TAG

then, open your browser and go to http://localhost:8888 for the Jupyter notebook web interface
(note: when using Docker Toolbox, replace localhost with the result of
`docker-machine ip default` command).

Alternatively, you can use the script [colomoto-docker.py](./colomoto-docker.py?raw=true) to ease docker
invocation:

    $ wget -O colomoto-docker.py https://raw.githubusercontent.com/colomoto/colomoto-docker/colomoto-docker.py
    $ python colomoto-docker -V TAG

If `TAG` is `latest`, it will automatically fetch the latest available tag.
See `python colomoto-docker -h` for usage.


## Embedded softwares

Besides the [Jupyter notebook](http://jupyter.org), the docker image provides
access to the following softwares:

* [GINsim](http://ginsim.org)
* [MaBoSS](https://maboss.curie.fr)
* [NuSMV](http://nusmv.fbk.eu)
* [Pint](http://loicpauleve.name/pint)


## Contribute

Coming soon: instruction to add/update your software


# Usage guide

## Without any installation

Visit [mybinder.org/v2/gh/colomoto/colomoto-docker/mybinder/latest](https://mybinder.org/v2/gh/colomoto/colomoto-docker/mybinder/latest) to launch the most recent CoLoMoTo Notebook environment without any installation thanks to [Binder](https://mybinder.org) services. You can replace `latest` with a specific [image tag](https://github.com/colomoto/colomoto-docker/releases).

Note that the computing resources are limited and the storage is not persistent.

## With Python Helper Script

To ease interaction with Docker, we provide a Python helper script [colomoto-docker](https://github.com/colomoto/colomoto-docker-py).
You need [Docker](https://docs.docker.com/get-docker/) and [Python](http://python.org).
We support GNU/Linux, macOS, and Windows.

    sudo pip install -U colomoto-docker   # only once; you may have to use pip3
    colomoto-docker

The container can be stopped by pressing <kbd>Ctrl</kbd>+<kbd>C</kbd> keys.

### Selecting image version

By default, the script will fetch the most recent [colomoto/colomoto-docker tag](https://github.com/colomoto/colomoto-docker/releases). A specific tag can be specified using the `-V` option; or use `-V same` to use the most recently fetched image. For example:

    colomoto-docker                 # uses the most recently fetched image
    colomoto-docker -V latest       # fetches the latest published image
    colomoto-docker -V 2018-05-29   # fetches a specific image

### Writing notebooks

**Warning**: by default, the files within the Docker container are isolated from the running host computer, therefore *files are deleted after stopping the container*, except the files within the `persistent` directory.

To have access to the files of your current directory you can use the `--bind` option:

    colomoto-docker --bind .

If you want to have the tutorial notebooks alongside your local files, you can
do the following:

    mkdir notebooks
    colomoto-docker -v notebooks:local-notebooks

in the Jupyter browser, you will see a `local-notebooks` directory which is
bound to your `notebooks` directory.

### Selecting interface

    colomoto-docker --lab          # laucnh Jupyter Lab interface (default)
    colomoto-docker --notebook     # launch Jupyter Notebook interface
    colomoto-docker --shell        # launch shell
    colomoto-docker command line   # execute command line in place of launching the interface

### Running old images

On some systems, older images may require changing default security options.

    colomoto-docker --ulimit nofile=8096 -V 2018-05-29


### Other options

See

    colomoto-docker --help

for other options.

### Issues

Having issues? have a look at our [Troubleshooting](https://github.com/colomoto/colomoto-docker/blob/master/TROUBLESHOOTING.md) page, or [open an issue](https://github.com/colomoto/colomoto-docker/issues).

## Python-less usage

You need [Docker](https://docs.docker.com/get-docker/).

First, pick an image version among [colomoto/colomoto-docker tags](https://github.com/colomoto/colomoto-docker/releases).
Fetch the image with

    docker pull colomoto/colomoto-docker:TAG

The image can be ran using

    docker run -it --rm -p 8888:8888 colomoto/colomoto-docker:TAG

then, open your browser and go to http://localhost:8888 for the Jupyter notebook web interface
(note: when using Docker Toolbox, replace localhost with the result of
`docker-machine ip default` command).

# colomoto-docker

## Get the docker image

### Fetch the latest docker image from DockerHub

    $ docker pull colomoto/colomoto-docker

### Build the docker image locally

The image is automatically built on pushes. If you want to build it locally, use the following command:

    $ docker build -t colomoto/colomoto-docker .


## Run the docker image

Run the image:

    $ docker run -it --rm -p 8888:8888 colomoto/colomoto-docker

Then go to http://localhost:8888 for the jupyter notebook web interface.

Alternatively you can use the script [colomoto-docker.py](./colomoto-docker.py?raw=true) to ease docker
invocation.

Script usage:

    $ python colomoto-docker.py -h

Run the image (access through port 8888):

    $ python colomoto-docker.py

Bind a local folder (eg to make a local notebook available in Jupyter):

    $ python colomoto-docker.py --bind /full/path/to/local/folder


# colomoto-docker

## Get the docker image

### Fetch the latest docker image from DockerHub

    $ docker pull colomoto/colomoto-docker

### Build the docker image locally

The image is automatically built on pushes. If you want to build it locally, use the following command:

    $ docker build -t colomoto/colomoto-docker .


## Run the docker image

Run the image using the 'docker run' command

    $ docker run -it --rm -p 8888:8888 colomoto/colomoto-docker

Then go to http://localhost:8888 for the jupyter notebook web interface.

NB: if you're running Docker Toolbox, you have to use the IP adress of the Docker default machine. This can be found using the following command:

    $ docker-machine ip default

Alternatively you can use the script [colomoto-docker.py](./colomoto-docker.py?raw=true) to ease docker
invocation.

Script usage:

    $ python colomoto-docker.py -h

Run the image (access through port 8888):

    $ python colomoto-docker.py

Bind a local folder (eg to make a local notebook available in Jupyter):

    $ python colomoto-docker.py --bind /full/path/to/local/folder


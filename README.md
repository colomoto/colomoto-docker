# colomoto-docker

## Run the docker image

Fetch the latest docker image:

    $ docker pull colomoto/colomoto-docker

Run the image:

    $ docker run -it --rm -p 8888:8888 colomoto/colomoto-docker

Then go to http://localhost:8888 for the jupyter notebook web interface.

Alternatively you can use the script [colomoto-docker.py](./colomoto-docker.py?raw=true) to ease docker
invocation:

    $ python colomoto-docker.py

## Compile the docker image

The image is automatically built on pushes. If you want to built it locally, use the following command:

    $ docker build -t colomoto/colomoto-docker .


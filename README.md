# colomoto-docker

## Run the docker image

    $ docker pull colomoto/colomoto-docker

    $ docker run -it --rm -p 8888:8888 colomoto/colomoto-docker

Then go to http://localhost:8888 for the jupyter notebook web interface.

## Compile the docker image

The image is automatically built on pushes. If you want to built it locally, use the following command:

    $ docker build -t colomoto/colomoto-docker .


# colomoto-docker

## Compile the docker image

    $ docker build -t colomoto-docker .

## Run the docker image

    $ docker run -it --rm -p 8888:8888 colomoto-docker

Then go to http://localhost:8888 for the jupyter notebook web interface.

## TODO
[] multi-stage for Dockerfile splitting


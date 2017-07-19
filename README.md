# colomoto-docker

## Run the docker image

Soon available:
    $ docker pull colomoto/colomoto-docker

    $ docker run -it --rm -p 8888:8888 colomoto/colomoto-docker

## Compile the docker image

    $ docker build -t colomoto/colomoto-docker .

Then go to http://localhost:8888 for the jupyter notebook web interface.

## TODO
- [ ] create a docker colomoto namespace; push the image
- [ ] multi-stage for Dockerfile splitting


FROM colomoto/colomoto-docker-base
MAINTAINER CoLoMoTo Group <contact@colomoto.org>

## NuSMV  - http://nusmv.fbk.eu/     https://github.com/colomoto/colomoto-conda
## Clingo - https://potassco.org/    https://github.com/colomoto/colomoto-conda
## MaBoSS - https://maboss.curie.fr  https://github.com/colomoto/colomoto-conda
RUN conda install --no-update-deps  -y \
        nusmv=2.6.0 \
        clingo=5.2.2 \
        maboss=2.0 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs


## GINsim - http://ginsim.org/             https://github.com/colomoto/colomoto-conda
## Pint - http://loicpauleve.name/pint     https://github.com/pauleve/pint
RUN conda install --no-update-deps -y \
        ginsim=2.9.6 \
        pint=2017.12.19 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs


## Python interfaces with Jupyter integration
## Colomoto-jupyter - https://github.com/colomoto/colomoto-jupyter  https://github.com/colomoto/colomoto-conda
## GINsim-python    - https://github.com/ginsim/ginsim-python       https://github.com/colomoto/colomoto-conda
## pyPint           - http://loicpauleve.name/pint                  https://github.com/pauleve/pint
RUN conda install --no-update-deps -y \
        colomoto_jupyter=0.4.1 \
        ginsim-python=0.2.90 \
        pymaboss=0.3.2 \
        pypint=1.3.93 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs \
    && pip install boolean.py       # extra dependencies

## Tutorials for individual tools
COPY tutorials /notebook/tutorials

## Examples of workflows
COPY usecases/*.ipynb /notebook/

ARG IMAGE_NAME
ARG IMAGE_BUILD_DATE
ARG SOURCE_COMMIT
ENV DOCKER_IMAGE=$IMAGE_NAME \
    DOCKER_BUILD_DATE=$IMAGE_BUILD_DATE \
    DOCKER_SOURCE_COMMIT=$SOURCE_COMMIT


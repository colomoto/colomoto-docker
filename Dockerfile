FROM colomoto/colomoto-docker-base:v1.2
MAINTAINER CoLoMoTo Group <contact@colomoto.org>

USER root

## NuSMV  - http://nusmv.fbk.eu/     https://github.com/colomoto/colomoto-conda
## Clingo - https://potassco.org
## MaBoSS - https://maboss.curie.fr  https://github.com/colomoto/colomoto-conda
RUN conda install --no-update-deps  -y \
        -c potassco \
        clingo=5.2.2 \
        nusmv=2.6.0 \
        nusmv-arctl=2.2.2 \
        maboss=2.0 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs


## GINsim - http://ginsim.org/             https://github.com/colomoto/colomoto-conda
## Pint - http://loicpauleve.name/pint     https://github.com/pauleve/pint
RUN conda install --no-update-deps -y \
        ginsim=3.0.0b=2 \
        pint=2018.03.22 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs


## Python interfaces with Jupyter integration
## Colomoto-jupyter - https://github.com/colomoto/colomoto-jupyter  https://github.com/colomoto/colomoto-conda
## GINsim-python    - https://github.com/ginsim/ginsim-python       https://github.com/colomoto/colomoto-conda
## pyPint           - http://loicpauleve.name/pint                  https://github.com/pauleve/pint
RUN conda install --no-update-deps -y \
        boolean.py=3.5+git=0 \
        colomoto_jupyter=0.4.6 \
        ginsim-python=0.3.0 \
        pymaboss=0.6.1 \
        pypint=1.4.1 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs

COPY validate.sh /usr/local/bin/


##
# Notebooks
##
## Tutorials for individual tools
#COPY --chown=user:user tutorials /notebook/tutorials
COPY usecases/*.ipynb /notebook/usecases/
COPY tutorials /notebook/tutorials

# hub.docker.org does not support COPY --chown yet
RUN chown -R user:user /notebook

USER user
ARG IMAGE_NAME
ARG IMAGE_BUILD_DATE
ARG BUILD_DATETIME
ARG SOURCE_COMMIT
ENV DOCKER_IMAGE=$IMAGE_NAME \
    DOCKER_BUILD_DATE=$IMAGE_BUILD_DATE \
    DOCKER_SOURCE_COMMIT=$SOURCE_COMMIT
LABEL org.label-schema.build-date=$BUILD_DATETIME \
    org.label-schema.name="The CoLoMoTo docker" \
    org.label-schema.url="http://colomoto.org/" \
    org.label-schema.vcs-ref=$SOURCE_COMMIT \
    org.label-schema.vcs-url="https://github.com/colomoto/colomoto-docker" \
    org.label-schema.schema-version="1.0"


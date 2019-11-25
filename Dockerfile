FROM colomoto/colomoto-docker-base:v1.6.4
MAINTAINER CoLoMoTo Group <contact@colomoto.org>

USER root

# IMPORTANT:
# DO NOT UPDATE PACKAGE VERSIONS MANUALLY
# USE python update-n-freeze.py

RUN conda install --no-update-deps  -y \
        -c potassco \
        clingo=5.4.0=py37lua53hf484d3e_0 \
        boolsim=1.2=0 \
        bns=1.3=0 \
        its=20180905=0 \
        nusmv=2.6.0=0 \
        nusmv-arctl=2.2.2=0 \
        maboss=2.2.3=h6bb024c_0 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs

RUN conda install --no-update-deps -y \
        ginsim=3.0.0b=8 \
        pint=2019.05.24=1 \
        r-boolnet=2.1.5 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs

RUN conda install --no-update-deps -y \
        boolean.py=3.7=py_0 \
        colomoto_jupyter=0.5.8=py_0 \
        ginsim-python=0.3.8=py_0 \
        pymaboss=0.7.8=py_0 \
        pypint=1.5.2=py_0 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs

COPY validate.sh /usr/local/bin/


##
# Notebooks
##
COPY --chown=user:user tutorials /notebook/tutorials
COPY --chown=user:user usecases/*.ipynb /notebook/usecases/

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


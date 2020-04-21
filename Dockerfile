FROM colomoto/colomoto-docker-base:py37-openjdk8-20200421

USER root

# IMPORTANT: DO NOT UPDATE PACKAGE VERSIONS MANUALLY

# HOW TO INCLUDE A TOOL:
# - specify its name only
# - prefer prefixing its channel (channel::package) if it is not conda-forge or colomoto
# - choose the appropriate install tier depending on its expected frequency update
# - insert it in alphabetic order of package name

# Tier 1: tools with rare updates (0-1/year)
RUN conda install --no-update-deps  -y \
        boolsim=1.2=0 \
        bns=1.3=0 \
        potassco::clingo=5.4.0=py37lua53hf484d3e_0 \
        its=20180905=0 \
        nusmv=2.6.0=0 \
        nusmv-arctl=2.2.2=0 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs

# Tier 2: tools with regular updates (2-4/year)
RUN conda install --no-update-deps -y \
        ginsim=3.0.0b=9 \
        maboss=2.3.1=h6bb024c_0 \
        pint=2019.05.24=1 \
        r-boolnet=2.1.5 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs

# Tier 3: tools with frequent updates (>4/year)
RUN conda install --no-update-deps -y \
        conda-forge::boolean.py=3.7=py_0 \
        colomoto_jupyter=0.6.2=py_0 \
        ginsim-python=0.4.1=py_0 \
        mpbn=1.2=py_0 \
        pymaboss=0.7.10=py_0 \
        pypint=1.6.0=py_0 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs

COPY validate.sh /usr/local/bin/


##
# Notebooks
##
COPY --chown=user:user tutorials /notebook/tutorials
COPY --chown=user:user usecases/*.ipynb /notebook/usecases/

USER user

RUN mkdir -p /notebook/.local/lib/python3.7/site-packages && \
    mkdir /notebook/persistent &&\
    touch /notebook/persistent/.keep

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


FROM debian:buster-20200414-slim

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

ARG NB_USER=user
ARG NB_UID=1000
RUN useradd -u $NB_UID -m -d /notebook -s /bin/bash $NB_USER

EXPOSE 8888
WORKDIR /notebook
ENTRYPOINT ["/usr/bin/tini", "--", "colomoto-env"]
CMD ["colomoto-nb", "--NotebookApp.token="]

##
## distribution packages
##
RUN apt-get update --fix-missing && \
    mkdir /usr/share/man/man1 && touch /usr/share/man/man1/rmid.1.gz.dpkg-tmp && \
    apt-get install -y --no-install-recommends \
        bzip2 \
        ca-certificates \
        wget \
        openjdk-11-jre-headless \
        && \
    apt clean -y && \
    rm -rf /var/lib/apt/lists/*

#
# tini for avoiding zombie processes (useless with Docker 1.13)
#
RUN TINI_VERSION="0.19.0" && \
    wget --quiet https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}-amd64.deb && \
    dpkg -i tini_${TINI_VERSION}-amd64.deb && \
    rm *.deb

#
# base conda environment
#
# package versions in this section are not pinned unless necessary
#
RUN CONDA_VERSION="py37_4.8.2" && \
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    conda config --set auto_update_conda False && \
    conda config --add channels conda-forge && \
    conda config --add channels colomoto && \
    conda install --no-update-deps -y \
        -c colomoto/label/fake \
        openjdk \
        pyqt && \
    conda clean -y --all && rm -rf /opt/conda/pkgs

# notebook dependencies
RUN conda install --no-update-deps -y \
        libgfortran \
        ipywidgets \
        'matplotlib>=1.3.1' \
        networkx \
        nomkl \
        notebook \
        pandas \
        pydot \
        'pygraphviz>=1.5' \
        rpy2 \
        seaborn \
        && \
    conda clean -y --all && rm -rf /opt/conda/pkgs


# IMPORTANT: DO NOT UPDATE PACKAGE VERSIONS MANUALLY

# HOW TO INCLUDE A TOOL:
# - specify its name only
# - prefer prefixing its channel (channel::package) if it is not conda-forge or colomoto
# - choose the appropriate install tier depending on its expected frequency update
# - insert it in alphabetic order of package name

# Tier 1: tools with rare updates (0-1/year) and thin dependencies
RUN AUTO_UPDATE=1 conda install --no-update-deps  -y \
        boolsim=1.2=0 \
        bns=1.3=0 \
        potassco::clingo=5.4.0=py37lua53hf484d3e_0 \
        its=20180905=0 \
        nusmv=2.6.0=0 \
        nusmv-arctl=2.2.2=0 \
        pint=2019.05.24=1 \
        r-boolnet=2.1.5 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs

# Tier 2: tools with regular updates (2-4/year)
RUN AUTO_UPDATE=1 conda install --no-update-deps -y \
        ginsim=3.0.0b=12 \
        maboss=2.3.4=h6bb024c_0 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs

# Tier 3: tools with frequent updates (>4/year) or lightweight with thin dependencies
RUN AUTO_UPDATE=1 conda install --no-update-deps -y \
        conda-forge::boolean.py=3.7=py_0 \
        casq=0.7.4=py_1 \
        colomoto_jupyter=0.6.4=py_0 \
        ginsim-python=0.4.2=py_0 \
        mpbn=1.2=py_0 \
        pymaboss=0.7.16=py_0 \
        pypint=1.6.0=py_0 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs

COPY validate.sh /usr/local/bin/
COPY bin/* /usr/bin/

##
# Notebooks
##
COPY --chown=$NB_USER:$NB_USER tutorials /notebook/tutorials
COPY --chown=$NB_USER:$NB_USER usecases/*.ipynb /notebook/usecases/

USER $NB_USER

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

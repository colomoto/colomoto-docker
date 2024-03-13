FROM debian:sid-20240211-slim

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /home/user/.local/bin:/opt/conda/bin:$PATH

ARG NB_USER=user
ARG NB_UID=1000
RUN useradd -u $NB_UID -m -d /home/user -s /bin/bash $NB_USER

EXPOSE 8888
WORKDIR /notebook
ENTRYPOINT ["/usr/bin/tini", "--", "colomoto-env"]
CMD ["colomoto-nb", "--NotebookApp.token="]

##
## distribution packages
##
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
        bzip2 \
        ca-certificates \
        wget\
        fontconfig\
        libharfbuzz0b\
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
RUN CONDA_VERSION="py311_23.11.0-2" && \
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    conda config --set auto_update_conda False && \
    conda config --append channels colomoto && \
    conda config --add channels conda-forge && \
    conda config --add channels potassco && \
    conda config --add channels colomoto/label/fake && \
    conda config --set solver libmamba && \
    conda update -y  \
        conda-libmamba-solver \
        libmamba \
        libmambapy \
        libarchive && \
    conda update --all -y && \
    conda install --no-update-deps -y \
        openjdk \
        pyqt=5.9.9999 && \
    find /opt/conda -name '*.a' -delete &&\
    conda clean -y --all && rm -rf /opt/conda/pkgs

RUN conda install -y \
        pyqt=5.9.9999 \
        graphviz \
        imagemagick \
        ipywidgets \
        matplotlib \
        networkx \
        nomkl \
        notebook \
        pandas \
        pyarrow \
        pydot \
        python-graphviz \
        seaborn \
        scikit-learn \
        && \
    find /opt/conda -name '*.a' -delete &&\
    conda clean -y --all && rm -rf /opt/conda/pkgs

# R
RUN conda install -y \
        'r-base>=4.1' \
        rpy2 \
        && \
    find /opt/conda -name '*.a' -delete &&\
    conda clean -y --all && rm -rf /opt/conda/pkgs

# tool dependencies being quite heavy
#     nordic: cmappy, cython, pydantic, qnorm
RUN conda install --no-update-deps -y -c bioconda \
        cmappy \
        cython \
        omnipath \
        qnorm \
        && \
    find /opt/conda -name '*.a' -delete &&\
    conda clean -y --all && rm -rf /opt/conda/pkgs

# IMPORTANT: DO NOT UPDATE PACKAGE VERSIONS MANUALLY

# HOW TO INCLUDE A TOOL:
# - specify its name only
# - choose the appropriate install tier depending on its expected frequency update
# - insert it in alphabetic order of package name

# Tier 1: tools with rare updates (0-1/year) and thin dependencies
RUN AUTO_UPDATE=1 conda install --no-update-deps  -y  \
        -c potassco -c bioasp \
        asprin=3.1.1=py_0 \
        boolsim=1.2=0 \
        booleannet=1.2.8=py_0 \
        bnettoprime=1.0=h6bb024c_0 \
        bns=1.3=0 \
        caspo=4.0.1=py_1 \
        clingo=5.7.1=py311h3fd9d12_0 \
        eqntott=1.0=1 \
        erode-python=0.7.2=py_0 \
        espresso-logic-minimizer=9999=h14c3975_0 \
        its=20210125=0 \
        nusmv=2.6.0=0 \
        nusmv-a=1.2=h6bb024c_0 \
        nusmv-arctl=2.2.2=0 \
        pint=2019.05.24=1 \
        r-boolnet=2.1.9 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs

# Tier 2: tools with regular updates (2-4/year)
RUN AUTO_UPDATE=1 conda install --no-update-deps -y \
        -c daemontus -c pauleve \
        libsbml-plus-packages=5.20.0=hbee6a8b_0 \
        biodivine_aeon=0.0.9a3=py311h9bf148f_0 \
        cabean=1.0.0=0 \
        ginsim=3.0.0b=12 \
        maboss=2.5.4=h2bc3f7f_1 \
        pyboolnet=3.0.10.post1=py_0 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs

# Tier 3: tools with frequent updates (>4/year) or lightweight with thin dependencies
RUN AUTO_UPDATE=1 conda install --no-update-deps -y \
        -c creda \
        algorecell_types=1.0=py_0 \
        bns-python=0.2=py_0 \
        bonesis=0.6.1=py_0 \
        boolsim-python=0.5=py_0 \
        cabean-python=1.0=py_0 \
        caspo-control=1.0=py_0 \
        casq=1.0.3=py_0 \
        colomoto_jupyter=0.8.8=py_0 \
        ginsim-python=0.4.3=py_0 \
        mpbn=3.3=py_0 \
        nordic=2.4.4=py_0 \
        pyactonet=1.0=py_0 \
        pymaboss=0.8.6=py_0 \
        pypint=1.6.3=py_0 \
        pystablemotifs=3.0.6=py_0 \
        scboolseq=2.0.1=py_0 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs

COPY validate.sh /usr/local/bin/
COPY bin/* /usr/bin/

##
# Notebooks
##
COPY --chown=$NB_USER:$NB_USER tutorials /notebook/tutorials

RUN chown $NB_USER:$NB_USER /notebook

USER $NB_USER

RUN mkdir -p /home/$NB_USER/.local/lib/python3.11/site-packages && \
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
    org.label-schema.schema-version="1.0"\
    org.opencontainers.image.source="https://github.com/colomoto/colomoto-docker"

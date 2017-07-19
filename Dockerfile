FROM ubuntu:latest
MAINTAINER CoLoMoTo Group <contact@colomoto.org>
WORKDIR /notebook
ENTRYPOINT ["tini", "--"]
CMD ["colomoto-nb", "--NotebookApp.token="]
EXPOSE 8888

ENV TINI_VERSION 0.13.1
RUN apt-get update \
    && apt-get install -y \
        gringo \
        libgmpxx4ldbl \
        openjdk-8-jre-headless \
        python3-pandas \
        python3-pip \
        python3-pygraphviz \
        r-mathlib \
    && apt-get clean \
    && pip3 install jupyter \
    && cd /usr/src \
    && curl -LO https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}-amd64.deb \
    && dpkg -i tini_${TINI_VERSION}-amd64.deb \
    && rm *.deb \
    && echo '#!/bin/bash' > /usr/bin/colomoto-nb \
    && echo 'jupyter notebook --allow-root --no-browser --ip=* --port 8888 "${@}"' >>/usr/bin/colomoto-nb \
    && chmod +x /usr/bin/colomoto-nb


##
## GINSim
##
ENV GINSIM_VERSION 2.9.6
RUN \
    curl -L http://ginsim.org/sites/default/files/ginsim-dev/GINsim-${GINSIM_VERSION}-SNAPSHOT-jar-with-dependencies.jar \
        -o /opt/GINsim.jar \
    && echo '#!/bin/bash' > /usr/bin/GINsim \
    && echo 'java -jar /opt/GINsim.jar "${@}"' >> /usr/bin/GINsim \
    && chmod +x /usr/bin/GINsim

##
## NuSMV
##
ENV NUSMV_VERSION 2.6.0
RUN cd /usr/local/src/ && \
    curl -LO http://nusmv.fbk.eu/distrib/NuSMV-${NUSMV_VERSION}-linux64.tar.gz && \
    tar -xvf NuSMV-${NUSMV_VERSION}-linux64.tar.gz && \
    rm NuSMV-${NUSMV_VERSION}-linux64.tar.gz && \
    ln -s /usr/local/src/NuSMV-${NUSMV_VERSION}-Linux/bin/NuSMV /usr/bin/NuSMV

##
## NuSMV-ARCTL
##
RUN apt-get install -y \
    bison\
    flex \
    gcc \
    libexpat1-dev\
    make \
    unzip \
    && ln -s /usr/lib/gcc/x86_64-linux-gnu/4.8.4/cc1 /usr/bin/cc1plus
RUN cd /usr/local/src/ && \
    curl -LO http://lvl.info.ucl.ac.be/pmwiki/uploads/Tools/NuSMV-ARCTL-TLACE/NuSMV-TLACE-Dec2013.zip && \
    unzip NuSMV-TLACE-Dec2013.zip && \
    rm NuSMV-TLACE-Dec2013.zip && \
    cd NuSMV/cudd-2.3.0.1/ && \
    make && \
    cd ../nusmv && \
    ./configure && \
    make && \
    make install && \
    mv /usr/local/bin/NuSMV /usr/local/bin/NuSMVARCTL && \
    rm -rf /usr/local/src/*

##
## Pint
##
ENV PINT_VERSION 2017-04-13
RUN cd /usr/src \
    && curl -LO https://github.com/pauleve/pint/releases/download/${PINT_VERSION}/pint_${PINT_VERSION}_amd64.deb \
    && dpkg -i pint_${PINT_VERSION}_amd64.deb \
    && pip3 install -U pypint


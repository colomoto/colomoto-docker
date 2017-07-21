## TO BE RESTORED WHEN MULTI-STAGE SUPPORTED ON HUB.DOCKER.COM (ETA AUG)
#FROM ubuntu:latest as builder
#WORKDIR /usr/local/src
#
#ENV COLOMOTO_DIST /opt/colomoto
#
#RUN mkdir -p ${COLOMOTO_DIST}/bin \
#    && apt-get update \
#    && apt-get install -y \
#            bison \
#            curl \
#            flex \
#            g++ \
#            gcc \
#            make
#
#### begin MaBoSS
###
#ENV MABOSS_VERSION 2.0
#RUN curl -L https://maboss.curie.fr/pub/MaBoSS-env-${MABOSS_VERSION}.tgz | tar xz \
#    && cd MaBoSS-env-${MABOSS_VERSION}/engine/src \
#    && make install \
#    && make MAXNODES=128 install \
#    && make MAXNODES=256 install \
#    && mv ../pub/MaBoSS* ${COLOMOTO_DIST}/bin \
#    && cd ../.. \
#    && mkdir -p ${COLOMOTO_DIST}/MaBoSS \
#    && mv tools doc tutorial examples ${COLOMOTO_DIST}/MaBoSS/
#### end


FROM ubuntu:latest
MAINTAINER CoLoMoTo Group <contact@colomoto.org>
WORKDIR /notebook
ENTRYPOINT ["tini", "--"]
CMD ["colomoto-nb", "--NotebookApp.token="]
EXPOSE 8888

ENV COLOMOTO_DIST /opt/colomoto
ENV PATH ${COLOMOTO_DIST}/bin:${PATH}

ENV TINI_VERSION 0.13.1
RUN apt-get update \
    && apt-get install -y \
        curl \
        gringo \
        openjdk-8-jre-headless \
        python3-pandas \
        python3-pip \
        python3-pygraphviz \
    && apt-get clean \
    && pip3 install jupyter \
    && cd /usr/src \
    && curl -LO https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}-amd64.deb \
    && dpkg -i tini_${TINI_VERSION}-amd64.deb \
    && rm *.deb \
    && echo '#!/bin/bash' > /usr/bin/colomoto-nb \
    && echo 'jupyter notebook --allow-root --no-browser --ip=* --port 8888 "${@}"' >>/usr/bin/colomoto-nb \
    && chmod +x /usr/bin/colomoto-nb


### begin NuSMV
##
ENV NUSMV_VERSION 2.6.0
RUN cd /usr/local/src/ \
    && curl -L http://nusmv.fbk.eu/distrib/NuSMV-${NUSMV_VERSION}-linux64.tar.gz | tar xz \
    && mv -v NuSMV-${NUSMV_VERSION}-Linux/bin/* /usr/local/bin/ \
    && rm -rf NuSMV-*
### end

### begin NuSMV-ARCTL
##
#ENV NUSMV_ARCTL_VERSION 2.2.2
#RUN curl -L http://pedromonteiro.org/software/NuSMV-32bit-${NUSMV_ARCTL_VERSION}-ARCTL \
#        -o /usr/local/bin/NuSMV-ARCTL \
#    && chmod +x /usr/local/bin/NuSMV-ARCTL
### end


### begin GINsim
##
ENV GINSIM_VERSION 2.9.6
RUN \
    curl -L http://ginsim.org/sites/default/files/ginsim-dev/GINsim-${GINSIM_VERSION}-SNAPSHOT-jar-with-dependencies.jar \
        -o /opt/GINsim.jar \
    && echo '#!/bin/bash' > /usr/bin/GINsim \
    && echo 'java -jar /opt/GINsim.jar "${@}"' >> /usr/bin/GINsim \
    && chmod +x /usr/bin/GINsim
### end


### begin Pint
##
ENV PINT_VERSION 2017-04-13
RUN apt-get install --no-install-recommends -y \
        libgmpxx4ldbl \
        python \
        r-mathlib \
    && apt-get clean \
    && cd /usr/local/src/ \
    && curl -LO https://github.com/pauleve/pint/releases/download/${PINT_VERSION}/pint_${PINT_VERSION}_amd64.deb \
    && dpkg -i pint_${PINT_VERSION}_amd64.deb && rm pint*.deb \
    && pip3 install -U pypint
### end

##
## Pull tools compiled by builder
##
#COPY --from=builder ${COLOMOTO_DIST} ${COLOMOTO_DIST}/
ENV MABOSS_VERSION 2.0
## TO BE REMOVED WHEN MULTI-STAGE SUPPORTED ON HUB.DOCKER.COM (ETA AUG)
RUN mkdir -p ${COLOMOTO_DIST}/bin \
    && apt-get install -y \
            bison \
            curl \
            flex \
            g++ \
            gcc \
            make \
    && cd /usr/local/src \
    && curl -L https://maboss.curie.fr/pub/MaBoSS-env-${MABOSS_VERSION}.tgz | tar xz \
    && cd MaBoSS-env-${MABOSS_VERSION}/engine/src \
    && make install \
    && make MAXNODES=128 install \
    && make MAXNODES=256 install \
    && mv ../pub/MaBoSS* ${COLOMOTO_DIST}/bin \
    && cd ../.. \
    && mkdir -p ${COLOMOTO_DIST}/MaBoSS \
    && mv tools doc tutorial examples ${COLOMOTO_DIST}/MaBoSS/ \
    && apt-get clean && cd / && rm -rf /usr/local/src/*
### end


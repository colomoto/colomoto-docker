FROM continuumio/miniconda3
MAINTAINER CoLoMoTo Group <contact@colomoto.org>

##
# The commands should be ordered such that the less updated ones are at the
# begnning and the most updated at the end of the file
##

#### Tiers 1: commands with rare updates (<1/year)

EXPOSE 8888
WORKDIR /notebook
ENTRYPOINT ["colomoto-env"]
COPY docker/colomoto-env /usr/bin/
CMD ["colomoto-nb", "--NotebookApp.token="]
COPY docker/colomoto-nb /usr/bin/

### Tiers 2: command with moderated update frequency (~1/year)

### Tiers 3: command with frequent update frequence (>=2-3/year)

RUN conda install -y -c bioconda -c colomoto -c conda-forge colomoto=0.2.2 &&  conda clean -y --all

COPY tutorials /notebook/tutorials


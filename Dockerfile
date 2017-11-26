FROM continuumio/miniconda3
MAINTAINER CoLoMoTo Group <contact@colomoto.org>

##
# The commands should be ordered such that the less updated ones are at the
# beginning and the most updated at the end of the file
##

#### Tiers 1: commands with rare updates (<1/year)

EXPOSE 8888
WORKDIR /notebook
ENTRYPOINT ["/usr/bin/tini", "--", "colomoto-env"]
CMD ["colomoto-nb", "--NotebookApp.token="]
COPY docker/colomoto-env /usr/bin/
COPY docker/colomoto-nb /usr/bin/

RUN conda config --add channels bioconda \
    && conda config --add channels colomoto

# notebook and useful extra python libraries
RUN conda install -y \
        notebook \
        pandas \
    && conda clean -y --all

## NuSMV - http://nusmv.fbk.eu/
# conda package repository: https://github.com/colomoto/colomoto-conda
RUN conda install -y \
        nusmv=2.6.0 \
    && conda clean -y --all

### Tiers 2: commands with moderated update frequency (~1/year)

## MaBoSS - https://maboss.curie.fr
# conda package repository: https://github.com/colomoto/colomoto-conda
RUN conda install -y \
        maboss=2.0 \
    && conda clean -y --all

## Clingo - https://potassco.org/
# conda package repository: https://github.com/colomoto/colomoto-conda
RUN conda install -y \
        clingo=5.2.2 \
    && conda clean -y --all

### Tiers 3: commands with high update frequency (>=2-3/year)

## GinSIM - http://ginsim.org/
# conda package repository: https://github.com/colomoto/colomoto-conda
RUN conda install --no-update-deps -y \
        'openjdk>=8,<9' \
        ginsim=2.9.6 \
    && conda clean -y --all

## Pint - http://loicpauleve.name/pint
# conda package repository: https://github.com/pauleve/pint
RUN conda install --no-update-deps -y \
        pint=2017.09.25 \
    && conda clean -y --all

## Colomoto-jupyter - https://github.com/colomoto/colomoto-jupyter
# conda package repository: https://github.com/colomoto/colomoto-conda
RUN conda install --no-update-deps -y \
        colomoto_jupyter=0.3.5 \
    && conda clean -y --all

## Python interfaces with Jupyter integration
## GINsim-python - https://github.com/ginsim/ginsim-python
# conda package repository: https://github.com/colomoto/colomoto-conda
## pyPint - http://loicpauleve.name/pint
# conda package repository: https://github.com/pauleve/pint
RUN conda install --no-update-deps -y \
        ginsim-python=0.2.1 \
        pypint=1.3.1 \
    && conda clean -y --all

## Tutorials for individual tools
COPY tutorials /notebook/tutorials


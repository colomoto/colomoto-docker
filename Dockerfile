FROM colomoto/colomoto-docker-base
MAINTAINER CoLoMoTo Group <contact@colomoto.org>

EXPOSE 8888
WORKDIR /notebook
ENTRYPOINT ["/usr/bin/tini", "--", "colomoto-env"]
CMD ["colomoto-nb", "--NotebookApp.token="]
COPY docker/colomoto-env /usr/bin/
COPY docker/colomoto-nb /usr/bin/

#### Commands with rare updates (<1/year)

## NuSMV  - http://nusmv.fbk.eu/     https://github.com/colomoto/colomoto-conda
## Clingo - https://potassco.org/    https://github.com/colomoto/colomoto-conda
## MaBoSS - https://maboss.curie.fr  https://github.com/colomoto/colomoto-conda
RUN conda install --no-update-deps  -y \
        nusmv=2.6.0 \
        clingo=5.2.2 \
        maboss=2.0 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs

### Commands with high update frequency (>=2-3/year)

## GINsim - http://ginsim.org/             https://github.com/colomoto/colomoto-conda
## Pint - http://loicpauleve.name/pint     https://github.com/pauleve/pint
RUN conda install --no-update-deps -y \
        ginsim=2.9.6 \
        pint=2017.09.25 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs


## Python interfaces with Jupyter integration
## Colomoto-jupyter - https://github.com/colomoto/colomoto-jupyter  https://github.com/colomoto/colomoto-conda
## GINsim-python    - https://github.com/ginsim/ginsim-python       https://github.com/colomoto/colomoto-conda
## pyPint           - http://loicpauleve.name/pint                  https://github.com/pauleve/pint
RUN conda install --no-update-deps -y \
        colomoto_jupyter=0.3.5 \
        ginsim-python=0.2.1 \
        pypint=1.3.1 \
    && conda clean -y --all && rm -rf /opt/conda/pkgs

## Tutorials for individual tools
COPY tutorials /notebook/tutorials


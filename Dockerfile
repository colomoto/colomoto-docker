FROM continuumio/miniconda3

MAINTAINER CoLoMoTo Group <contact@colomoto.org>
WORKDIR /notebook
ENTRYPOINT ["tini", "--"]
CMD ["colomoto-nb", "--NotebookApp.token="]
EXPOSE 8888

RUN conda install -y -c colomoto -c conda-forge colomoto &&  conda clean -y --all


RUN echo '#!/bin/bash' > /usr/bin/colomoto-nb \
    && echo 'jupyter-notebook --allow-root --no-browser --ip=* --port 8888 "${@}"' >>/usr/bin/colomoto-nb \
    && chmod +x /usr/bin/colomoto-nb


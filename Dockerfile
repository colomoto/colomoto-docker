FROM continuumio/miniconda3

MAINTAINER CoLoMoTo Group <contact@colomoto.org>
WORKDIR /notebook
CMD ["colomoto-nb", "--NotebookApp.token="]
EXPOSE 8888

RUN conda install -y -c colomoto -c conda-forge colomoto=0.2.2 &&  conda clean -y --all && \
    echo '#!/bin/bash' > /usr/bin/colomoto-nb && \
    echo 'jupyter-notebook --allow-root --no-browser --ip=* --port 8888 "${@}"' >>/usr/bin/colomoto-nb && \
    chmod +x /usr/bin/colomoto-nb


ARG BASE_CONTAINER=jupyter/datascience-notebook
FROM $BASE_CONTAINER

LABEL authors="Candice Hermant" \
      description="Docker image containing all requirements for the downstream analysis of iCLIP data"

# Configure bioconda
RUN conda config --add channels defaults && \
    conda config --add channels bioconda && \
    conda config --add channels conda-forge;

# R packages
RUN conda install --quiet --yes \
    'bioconductor-s4vectors' \
    'r-ggthemes' \
    'r-cowplot' \
    'bioconductor-genomicranges' \
    && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

#RUN pip install tensorflow~=2.1.0 && \
 #   pip install biomart && \
  #  pip install gtfparse~=1.2.0 && \
  #  pip install jupyter_contrib_nbextensions

RUN fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
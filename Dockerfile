# User can select the base image.
# For BASE_CONTAINER choices, see https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html

ARG BASE_CONTAINER=jupyter/minimal-notebook
FROM ${BASE_CONTAINER}

ENV REFRESHED_AT=2019-02-18

# -----------------------------------------------------------------------------
# OS infrastructure
# -----------------------------------------------------------------------------

USER root

# Update OS packages.

RUN apt-get update
RUN apt-get -y upgrade
RUN apt -y autoremove

# Install packages via apt.

RUN apt-get -y install \
      curl \
      gnupg \
      jq \
      python-dev \
      python-pip \
      python-pyodbc \
      wget \
 && rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# Python infrastructure
# -----------------------------------------------------------------------------

# Update Anaconda.

RUN conda update -y -n base conda

# Create a Python 2 environment.

RUN conda create -n ipykernel_py2 python=2 ipykernel

# Python libraries for python 2.7 from "anaconda" channel.

RUN conda install -n ipykernel_py2 -c anaconda -y \
      ipykernel \
      ipython \
      networkx \
      numpy \
      pandas \
      pandas-datareader \
      plotly \
      psutil \
      pyodbc \
      qgrid \
      seaborn \
      sympy \
      version_information

# Install python libraries from specific conda channels.

RUN conda install -n ipykernel_py2 -c conda-forge -y \
      ipywidgets \
      widgetsnbextension

RUN conda install -n ipykernel_py2 -c pyviz -y \
      bokeh \
      holoviews

# Install jupyter widgets for qgrid.

RUN conda run -n ipykernel_py2 jupyter labextension install @jupyter-widgets/jupyterlab-manager

# Enable qgrid inside jupyter notebooks.

RUN conda run -n ipykernel_py2 jupyter labextension install qgrid

# Install python 2.7 kernel for users.

RUN conda run -n ipykernel_py2 python -m ipykernel install --user

# Update nodeJS.

RUN npm i -g npm

# -----------------------------------------------------------------------------
# Prepare user home dir
# -----------------------------------------------------------------------------

# Copy files from repository.

COPY ./notebooks /home/$NB_USER/

# Adjust permissions

RUN chown -R $NB_UID:$NB_GID /home/$NB_USER
RUN chmod -R ug+rw /home/$NB_USER

# -----------------------------------------------------------------------------
# User environment setting
# -----------------------------------------------------------------------------

# Return to original user.
# Defined in https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile

USER $NB_UID

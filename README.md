# docker-jupyter-statpack

## Overview

The `senzing/jupyter-statpack` docker image is a Senzing-ready, python 2.7 image hosting
[jupyter](https://jupyter.org/).

These notebooks are built upon the DockerHub
[Jupyter organization](https://hub.docker.com/u/jupyter) docker images.
The default base image is [jupyter/minimal-notebook](https://hub.docker.com/r/jupyter/minimal-notebook).
There is more information on the
[Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io).

### Contents

1. [Expectations](#expectations)
    1. [Space](#space)
    1. [Time](#time)
    1. [Background knowledge](#background-knowledge)
1. [Prerequisite software](#prerequisite-software)
    1. [git](#git)
    1. [docker](#docker)
    1. [make](#make)
1. [Demonstrate](#demonstrate)
    1. [Set environment variables](#set-environment-variables)
    1. [Clone repository](#clone-repository)
    1. [Build docker image](#build-docker-image)
    1. [Configuration](#configuration)
    1. [Run docker container](#run-docker-container)
    1. [Run Jupyter](#run-jupyter)
1. [Develop](#develop)
    1. [Build docker image for development](#build-docker-image-for-development)
1. [Reference](#reference)

## Expectations

### Space

This repository and demonstration require 3 GB free disk space.

### Time

Budget 40 minutes to get the demonstration up-and-running, depending on CPU and network speeds.

### Background knowledge

This repository assumes a working knowledge of:

1. [Docker](https://github.com/Senzing/knowledge-base/blob/master/WHATIS/docker.md)
1. [Jupyter](https://github.com/Senzing/knowledge-base/blob/master/WHATIS/jupyter.md)

## Prerequisite software

The following software programs need to be installed.

### git

1. [Install Git](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-git.md)
1. Test

    ```console
    git --version
    ```

### docker

1. [Install docker](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-docker.md)
1. Test

    ```console
    sudo docker --version
    sudo docker run hello-world
    ```

### make

Optional: Only used during development.

1. [Install make](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-make.md)
1. Test

    ```console
    make --version
    ```

## Demonstrate

### Set environment variables

1. These variables may be modified, but do not need to be modified.
   The variables are used throughout the installation procedure.

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=docker-jupyter-statpack
    export DOCKER_IMAGE_TAG=senzing/jupyter-statpack
    ```

1. Synthesize environment variables.

    ```console
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    export GIT_REPOSITORY_URL="git@github.com:${GIT_ACCOUNT}/${GIT_REPOSITORY}.git"
    ```

### Clone repository

1. Get repository.

    ```console
    mkdir --parents ${GIT_ACCOUNT_DIR}
    cd  ${GIT_ACCOUNT_DIR}
    git clone ${GIT_REPOSITORY_URL}
    ```

### Build docker image

```console
sudo docker build --tag senzing/jupyter-statpack https://github.com/senzing/docker-jupyter-statpack.git
```

### Configuration

- **SENZING_STATPACK_DATA** -
  Directory hosting statpack data.  For use in docker container.
- **WEBAPP_PORT** -
  The port that is used to expose the Jupyter notebooks.

### Run docker container

1. Variation #1 - Run the docker container with volumes and internal database and token authentication. Example:

    ```console
    export WEBAPP_PORT=8888
    export SENZING_STATPACK_DATA_DIR=${GIT_REPOSITORY_DIR}/data

    sudo docker run -it \
      --volume ${SENZING_STATPACK_DATA_DIR}:/data \
      --publish ${WEBAPP_PORT}:8888 \
      senzing/jupyter-statpack
    ```

1. Variation #2 - Like Variation #1 but without token authentication. Example:

    ```console
    export WEBAPP_PORT=8888
    export SENZING_STATPACK_DATA_DIR=${GIT_REPOSITORY_DIR}/data

    sudo docker run -it \
      --volume ${SENZING_STATPACK_DATA_DIR}:/data \
      --publish ${WEBAPP_PORT}:8888 \
      senzing/jupyter-statpack \
        start.sh jupyter notebook --NotebookApp.token=''
    ```

1. Variation #3 - Like Variation #1 but without token authentication and external notebooks. Example:

    ```console
    export WEBAPP_PORT=8888
    export SENZING_STATPACK_DATA_DIR=${GIT_REPOSITORY_DIR}/data
    export SENZING_STATPACK_NOTEBOOK_DIR=~/notebooks


    sudo docker run -it \
      --volume ${SENZING_STATPACK_DATA_DIR}:/data \
      --volume ${SENZING_STATPACK_NOTEBOOK_DIR}:/home/joyvan/external \
      --publish ${WEBAPP_PORT}:8888 \
      senzing/jupyter-statpack \
        start.sh jupyter notebook --NotebookApp.token=''
    ```


### Run Jupyter

1. If no token authentication (Variation #2), access your jupyter notebooks at: [http://127.0.0.1:8888/](http://127.0.0.1:8888/)

1. If token authentication, locate the URL in the Docker log.  Example:

    ```console
    Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://(a152e5586fdc or 127.0.0.1):8888/?token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    ```

    Adjust the URL.  Example:

    ```console
    http://127.0.0.1:8888/?token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    ```

    Paste the URL into a web browser.

## Develop

### Build docker image for development

1. Variation #1 - Using make command

    ```console
    cd ${GIT_REPOSITORY_DIR}
    make docker-build
    ```

1. Variation #2 - Using docker command

    ```console
    cd ${GIT_REPOSITORY_DIR}
    docker build --tag ${DOCKER_IMAGE_TAG} .
    ```

## Reference

1. [A gallery of interesting Jupyter Notebooks](https://github.com/jupyter/jupyter/wiki/A-gallery-of-interesting-Jupyter-Notebooks)
1. [Holoviews gallery][(http://holoviews.org/gallery/index.html)
FROM nvidia/cuda:10.1-devel-ubuntu16.04

USER root

ENV HOME="/root/" \
    BLOND_DIR="$HOME/git/blond"
    INSTALL_DIR="$HOME/install"
    VIRTUAL_ENV="$HOME/venv"

WORKDIR $HOME

# COPY .bashrc .git-completion.bash .git-prompt.sh $HOME/
# COPY cuda_10.1.105_418.39_linux.run $HOME/

RUN apt-get update -y && \
apt-get -yq --no-install-suggests --no-install-recommends install apt-utils build-essential mpich libmpich-dev libfftw3-dev vim wget git \
    software-properties-common && \
add-apt-repository ppa:deadsnakes/ppa && \
apt-get update -y && apt-get -yq --no-install-suggests --no-install-recommends install python3.7

# RUN cd $HOME && sh cuda_10.1.105_418.39_linux.run --toolkit --silent --samples

# RUN python3.7 -m pip install virtualenv
# RUN python3.7 -m virtualenv --python=/usr/bin/python3.7 $VIRTUAL_ENV
# ENV PATH="$VIRTUAL_ENV/bin:$PATH"


RUN mkdir $HOME/git && cd $HOME/git && \
git clone --branch=gpu-dev https://github.com/kiliakis/BLonD-1.git $BLOND_DIR && \
git clone https://github.com/kiliakis/pyprof.git && \
git clone https://github.com/kiliakis/config.git

COPY pymodules $HOME/git/pymodules

RUN cd $BLOND_DIR && \
    python3 -m pip install --upgrade pip setuptools wheel && \
    python3 -m pip install -r requirements.txt

RUN cd $BLOND_DIR && python blond/compile.py -p --with-fftw --with-fftw-threads -gpu

COPY input_files $BLOND_DIR/__EXAMPLES/input_files/

ENV LD_LIBRARY_PATH=$HOME/install/lib
ENV PATH=$HOME/install/bin:$PATH
ENV PYTHONPATH=$BLOND_DIR:$HOME/git/pymodules:$HOME/git:$PYTHONPATH

FROM nvidia/cuda:10.1-devel-ubuntu18.04

USER root

ENV HOME="/root/" \
    BLOND_DIR="$HOME/git/blond" \
    INSTALL_DIR="$HOME/install" \
    VIRTUAL_ENV="$HOME/venv" \
    PYTHON="python3.7"

WORKDIR $HOME

# COPY .bashrc .git-completion.bash .git-prompt.sh $HOME/
# COPY cuda_10.1.105_418.39_linux.run $HOME/

RUN apt-get update -y && \
apt-get -yq --no-install-suggests --no-install-recommends install apt-utils build-essential mpich libmpich-dev libfftw3-dev vim wget git \
    software-properties-common curl && \
add-apt-repository ppa:deadsnakes/ppa && \
apt-get update -y && apt-get -yq --no-install-suggests --no-install-recommends install $PYTHON-dev

# RUN cd $HOME && sh cuda_10.1.105_418.39_linux.run --toolkit --silent --samples

# RUN $PYTHON -m pip install virtualenv
# RUN $PYTHON -m virtualenv --python=/usr/bin/$PYTHON $VIRTUAL_ENV
# ENV PATH="$VIRTUAL_ENV/bin:$PATH"


RUN mkdir $HOME/git && cd $HOME/git && \
git clone --branch=gpu-dev https://github.com/kiliakis/BLonD-1.git $BLOND_DIR && \
git clone https://github.com/kiliakis/pyprof.git && \
git clone https://github.com/kiliakis/config.git && \
mkdir $HOME/git/pymodules

COPY ./pymodules $HOME/git/pymodules/

RUN apt-get -yq install $PYTHON-dev

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    $PYTHON get-pip.py && \
   cd $BLOND_DIR && \
   $PYTHON -m pip install --upgrade pip setuptools wheel && \
   $PYTHON -m pip install -r requirements.txt && \
   $PYTHON blond/compile.py -p --with-fftw --with-fftw-threads -gpu

COPY ./input_files $BLOND_DIR/__EXAMPLES/input_files/

#ENV LD_LIBRARY_PATH=$HOME/install/lib
#ENV PATH=$HOME/install/bin:$PATH
#ENV PYTHONPATH=$BLOND_DIR:$HOME/git/pymodules:$HOME/git:$PYTHONPATH

FROM nvidia/cuda:10.1-devel-ubuntu18.04

USER root

ENV HOME="/root/" \
    BLOND_DIR="$HOME/git/blond" \
    INSTALL_DIR="$HOME/install" \
    VIRTUAL_ENV="$HOME/venv" \
    PYTHON="python3" \
    TZ="Europe/Athens"

WORKDIR $HOME


# COPY .bashrc .git-completion.bash .git-prompt.sh $HOME/
# COPY cuda_10.1.105_418.39_linux.run $HOME/
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -y && \
apt-get -yq --no-install-suggests --no-install-recommends install apt-utils build-essential mpich libmpich-dev libfftw3-dev vim wget git \
    software-properties-common curl htop systemd python3 python3-dev
#add-apt-repository ppa:deadsnakes/ppa && \
#apt-get update -y && apt-get -yq --no-install-suggests --no-install-recommends install $PYTHON-dev

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
# RUN cd $HOME && sh cuda_10.1.105_418.39_linux.run --toolkit --silent --samples

# RUN $PYTHON -m pip install virtualenv
# RUN $PYTHON -m virtualenv --python=/usr/bin/$PYTHON $VIRTUAL_ENV
# ENV PATH="$VIRTUAL_ENV/bin:$PATH"


RUN mkdir $HOME/git && cd $HOME/git && \
    git clone --branch=gpu-dev https://github.com/kiliakis/BLonD-1.git $BLOND_DIR && \
    git clone https://github.com/kiliakis/pyprof.git && \
    git clone --branch=blond-docker https://github.com/kiliakis/config.git && \
    mkdir $HOME/git/pymodules && \
    cd $HOME/git/config && cp -r .bash* .git-* .gitconfig .vim* $HOME/ && \
    echo "export BLONDHOME=$HOME/git/blond" >> $HOME/.bashrc && \
    echo "export PYTHONPATH=$HOME/git/pymodules/:$HOME/git:$PYTHONPATH" >> $HOME/.bashrc


COPY ./pymodules $HOME/git/pymodules/

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    $PYTHON get-pip.py && \
   cd $BLOND_DIR && \
   $PYTHON -m pip install --upgrade pip setuptools wheel pyyaml && \
   $PYTHON -m pip install -r requirements.txt && \
   $PYTHON blond/compile.py -p --with-fftw --with-fftw-threads -gpu

COPY ./input_files $BLOND_DIR/__EXAMPLES/input_files/

#ENV LD_LIBRARY_PATH=$HOME/install/lib
#ENV PATH=$HOME/install/bin:$PATH
#ENV PYTHONPATH=$BLOND_DIR:$HOME/git/pymodules:$HOME/git:$PYTHONPATH
ENTRYPOINT ["/bin/sleep", "365d"]

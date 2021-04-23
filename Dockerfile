# FROM nvidia/cuda:10.1-devel-ubuntu18.04
FROM 172.9.0.240:5000/evolve-zeppelin-gpu:0.9.0.4.3

USER root

ENV HOME="/root/" \
    BLOND_DIR="/root/git/blond" \
    INSTALL_DIR="/root/install" \
    PYTHON="python3.7"

WORKDIR $HOME


# COPY .bashrc .git-completion.bash .git-prompt.sh $HOME/
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update -y && \
    apt-get -yq --no-install-suggests --no-install-recommends install apt-utils \
    gcc-7 g++-7 build-essential mpich libmpich-dev libfftw3-dev vim wget git \
    software-properties-common curl htop systemd

COPY ./cuda_10.1.105_418.39_linux.run $HOME/

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 1 \
    --slave /usr/bin/g++ g++ /usr/bin/g++-7 && \
    cd $HOME && sh cuda_10.1.105_418.39_linux.run --toolkit --silent --samples

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
COPY ./input_files $BLOND_DIR/__EXAMPLES/input_files/

RUN cd $BLOND_DIR && \
   $PYTHON -m pip install --upgrade pip setuptools wheel pyyaml && \
   $PYTHON -m pip install -r requirements.txt && \
   $PYTHON blond/compile.py -p --with-fftw --with-fftw-threads -gpu


#ENTRYPOINT ["/bin/sleep", "365d"]

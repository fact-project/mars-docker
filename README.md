# mars-docker

A docker image for MARS

After cloning this repo you can do

```
$ docker build -t mars .
$ docker run --rm -i -t mars
```
`-i` is for interactive, `-t mars` specifiies the tag for the container, `--rm` deletes the container after you are done.

If you want to build `root` and `Mars` with more than 1 core, use:

```
$ docker build --build-arg CORES=24 -t mars .
```

## Mounting data volumes

To access raw data and write out analysis results, you weill probably need to mount volumes into the container.
This is done with the `-v /path/on/your/machine:/path/in/docker/image` option to `docker run`.

E.g.:
```
$ docker run -v /fact/raw:/fact/raw -v /gpfs1/scratch:/output --rm -i -t mars
```

## Install on your host


    sudo apt-get update \
        && apt-get install -y  git dpkg-dev make g++ gcc binutils \
        libx11-dev libxpm-dev libxft-dev libxext-dev htop \
        build-essential curl gfortran libssl-dev libpcre3-dev \
        xlibmesa-glu-dev libglew1.5-dev libftgl-dev \
        libmysqlclient-dev libfftw3-dev libcfitsio-dev \
        graphviz-dev libavahi-compat-libdnssd-dev \
        libldap2-dev python-dev libxml2-dev libkrb5-dev \
        libgsl0-dev libqt4-dev cmake subversion libnova-dev vim


    curl -O -L https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh
    bash Anaconda3-4.4.0-Linux-x86_64.sh -p $HOME/anaconda36 -b
    rm Anaconda3-4.4.0-Linux-x86_64.sh


    git clone https://github.com/root-mirror/root \
            --branch=v5-34-00-patches \
            --depth=1 \

    git clone https://github.com/fact-project/mars-docker.git

    cd root
    patch -p1 < ../mars-docker/root5-python3.patch
    cd ..
    rm -rf mars-docker

    mkdir build_root
    cd build_root
    cmake \
        -D builtin_zlib=ON \
        -D mathmore=ON \
        -D minuit2=ON \
        -D PYTHON_EXECUTABLE=$HOME/anaconda36/bin/python \
        -D PYTHON_INCLUDE_DIR=$HOME/anaconda36/include/python3.6m \
        -D PYTHON_LIBRARY=$HOME/anaconda36/lib/libpython3.6m.so \
        ../root

    cmake --build . -- -j7


    export PATH="$HOME/anaconda36/bin:$PATH"
    conda install libgcc=5
    conda clean --all --yes

    svn checkout -r 18868 \
        https://trac.fact-project.org/svn/trunk/Mars \
        --trust-server-cert \
        --non-interactive
    cd Mars
    make mrproper
    make -j7

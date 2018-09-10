FROM ubuntu:16.04
MAINTAINER FACT People <kai.bruegge@tu-dortmund.de>

ARG CORES=4

RUN apt-get update \
	&& apt-get install -y  git dpkg-dev make g++ gcc binutils \
	libx11-dev libxpm-dev libxft-dev libxext-dev htop \
	build-essential curl gfortran libssl-dev libpcre3-dev \
	xlibmesa-glu-dev libglew1.5-dev libftgl-dev \
	libmysqlclient-dev libfftw3-dev libcfitsio-dev \
	graphviz-dev libavahi-compat-libdnssd-dev \
	libldap2-dev python-dev libxml2-dev libkrb5-dev \
	libgsl0-dev libqt4-dev cmake subversion libnova-dev vim

RUN useradd -m mars

WORKDIR /home/mars

RUN curl -O -L https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh \
	&& bash Anaconda3-5.2.0-Linux-x86_64.sh -p /home/mars/anaconda3 -b \
	&& rm  Anaconda3-5.2.0-Linux-x86_64.sh \
	&& /home/mars/anaconda3/bin/conda clean --all --yes


RUN curl -L https://github.com/root-project/root/archive/v5-34-00-patches.tar.gz | tar xz \
    && mkdir build_root \
	&& cd build_root \
	&& cmake \
		-D builtin_zlib=ON \
		-D mathmore=ON \
  		-D minuit2=ON \
  		-D PYTHON_EXECUTABLE=/home/mars/anaconda3/bin/python \
  		-D PYTHON_INCLUDE_DIR=/home/mars/anaconda3/include/python3.6m \
  		-D PYTHON_LIBRARY=/home/mars/anaconda3/lib/libpython3.6m.so \
		../root-5-34-00-patches \
	&& cmake --build . -- -j$CORES \
	&& cmake --build . --target install \
	&& ldconfig \
	&& cd /home/mars \
	&& rm -rf /home/mars/build_root \
	&& rm -rf /home/mars/root-5-34-00-patches

RUN svn checkout -r 19227 https://trac.fact-project.org/svn/trunk/Mars --trust-server-cert --non-interactive \
	&& cd Mars \
	&& make mrproper \
	&& make -j$CORES  \
	&& cp libmars.so /usr/lib

ENV PATH=/home/mars/anaconda3/bin:$PATH

ADD rootrc  /home/mars/.rootrc
RUN chown mars:mars /home/mars/.rootrc 

WORKDIR /home/mars/Mars
CMD bash

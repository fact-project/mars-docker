FROM ubuntu:14.04
MAINTAINER FACT People <kai.bruegge@tu-dortmund.de>

ARG CORES=1

RUN apt-get update \
	&& apt-get install -y  git dpkg-dev make g++ gcc binutils \
	libx11-dev libxpm-dev libxft-dev libxext-dev htop \
	build-essential curl gfortran libssl-dev libpcre3-dev \
	xlibmesa-glu-dev libglew1.5-dev libftgl-dev \
	libmysqlclient-dev libfftw3-dev cfitsio-dev \
	graphviz-dev libavahi-compat-libdnssd-dev \
	libldap2-dev python-dev libxml2-dev libkrb5-dev \
	libgsl0-dev libqt4-dev cmake subversion libnova-dev

RUN useradd -m mars

WORKDIR /home/mars

RUN curl https://root.cern.ch/download/root_v5.34.36.source.tar.gz | tar xz
 
RUN mkdir build_root \
	&& cd build_root \
	&& cmake ../root \
	&& cmake --build . -- -j$CORES \
	&& cmake --build . --target install \
	&& ldconfig \
	&& cd /home/mars \
	&& rm -rf /home/mars/build_root

RUN svn checkout -r 18549 https://trac.fact-project.org/svn/trunk/Mars --trust-server-cert --non-interactive

RUN cd Mars \
	&& make mrproper \
	&& sed -i.bak '/#define sqrt ::sqrt/d' ./mbase/MQuaternion.h \
	&& sed -i.bak '/#undef sqrt/d' ./mbase/MQuaternion.h \
	&& make -j$CORES  \
	&& cp libmars.so /usr/lib

ADD rootrc  /home/mars/.rootrc
RUN chown mars:mars /home/mars/.rootrc 

WORKDIR /home/mars/Mars
USER mars
CMD bash

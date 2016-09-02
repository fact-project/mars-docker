FROM ubuntu:14.04
MAINTAINER FACT People <kai.bruegge@tu-dortmund.de>

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update && apt-get install -y  htop build-essential wget
RUN apt-get install -y  git dpkg-dev make g++ gcc binutils libx11-dev libxpm-dev libxft-dev libxext-dev
RUN apt-get install -y gfortran libssl-dev libpcre3-dev xlibmesa-glu-dev libglew1.5-dev libftgl-dev \
libmysqlclient-dev libfftw3-dev cfitsio-dev \
graphviz-dev libavahi-compat-libdnssd-dev \
libldap2-dev python-dev libxml2-dev libkrb5-dev \
libgsl0-dev libqt4-dev

RUN useradd mars
RUN mkdir /home/mars && chown -R mars: /home/mars && cd /home/mars
WORKDIR /home/mars
ENV HOME /home/mars
RUN wget https://root.cern.ch/download/root_v5.34.36.source.tar.gz
RUN tar zxvf root_v5.34.36.source.tar.gz 
 
RUN cd root && ./configure linuxx8664gcc  --all && make -j 8
#RUN /bin/bash -c 'source bin/thisroot.sh' 
RUN cd /home/mars
RUN source root/bin/thisroot.sh

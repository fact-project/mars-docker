FROM ubuntu:14.04
MAINTAINER FACT People <kai.bruegge@tu-dortmund.de>

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update && apt-get install -y  htop build-essential wget
RUN apt-get install -y  git dpkg-dev make g++ gcc binutils libx11-dev libxpm-dev libxft-dev libxext-dev
RUN apt-get install -y gfortran libssl-dev libpcre3-dev xlibmesa-glu-dev libglew1.5-dev libftgl-dev \
libmysqlclient-dev libfftw3-dev cfitsio-dev \
graphviz-dev libavahi-compat-libdnssd-dev \
libldap2-dev python-dev libxml2-dev libkrb5-dev \
libgsl0-dev libqt4-dev cmake

RUN useradd mars
RUN mkdir /home/mars && chown -R mars: /home/mars && cd /home/mars
WORKDIR /home/mars
ENV HOME /home/mars
RUN wget https://root.cern.ch/download/root_v5.34.36.source.tar.gz
RUN tar zxvf root_v5.34.36.source.tar.gz 
 
RUN mkdir build_root &&cd build_root  && cmake ../root  && cmake --build . -- -j14 && cmake --build . --target install
#RUN cmake -DCMAKE_INSTALL_PREFIX=/opt/root -P cmake_install.cmake
#ENV PATH /opt/root/bin:/opt/:$PATH
#RUN make install
RUN cd /home/mars
RUN apt-get install -y subversion libnova-dev
RUN svn checkout -r 18549 https://trac.fact-project.org/svn/trunk/Mars --trust-server-cert --non-interactive
RUN cd Mars && sed -i.bak '/#define sqrt ::sqrt/d' ./mbase/MQuaternion.h && sed -i.bak '/#undef sqrt/d' ./mbase/MQuaternion.h && make -j 4 && cp libmars.so /usr/lib

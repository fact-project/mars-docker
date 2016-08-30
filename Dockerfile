FROM ubuntu:14.04
MAINTAINER FACT People <kai.bruegge@tu-dortmund.de>

RUN apt-get update && apt-get install -y  htop iotop
RUN apt-get install -y build-essential


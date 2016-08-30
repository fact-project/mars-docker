FROM ubuntu:14.0
MAINTAINER FACT People <kai.bruegge@tu-dortmund.de>

RUN apt-get update && apt-get install htop iotop
RUN apt-get install build-essential


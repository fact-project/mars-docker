# mars-docker

A docker image for MARS

After cloning this repo you can do

```
$ docker build -t mars .
$ docker run -it mars bash
```

If you want to build `root` and `Mars` with more than 1 core, use:

```
$ docker build --build-arg CORES=24 -t mars .
```

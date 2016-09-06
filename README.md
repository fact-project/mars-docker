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

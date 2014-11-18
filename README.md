# Docker-based omnibus build lab template
This repo provides a set of "templates" you can use to create your own docker-based omnibus build lab. It's current `x86_64`/`amd64` only.

## Usage
You can either just run `make images` from the top-level directory to get a set of base images (everything needed to run omnibus) or you can copy a given directory into your own project and use it.

If you go the base images route, then your Dockerfiles will be much simpler as you just need to import those base images. These Dockerfiles build a docker base image that matches exactly what the omnibus cookbook applies to nodes to prep them with the exception of using a system ruby > 1.9 where available.

## Example of using these in your own project
Let's assume you went the route of building all of these base images, you'll now have a list of images like so available locally (sizes may vary):

```
jvbuntu :: ~ » docker images
REPOSITORY                	TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
omnibus-wheezy-base            latest              4b306d7ca5a4        21 minutes ago      544.9 MB
omnibus-trusty-base            latest              133d41ac2bdf        23 minutes ago      488.3 MB
omnibus-precise-base           latest              6149a73ac172        25 minutes ago      398.8 MB
omnibus-centos7-base           latest              edbf10af5969        26 minutes ago      1.26 GB
omnibus-centos6-base           latest              d209ec8a6164        28 minutes ago      906.7 MB
```

In your own Dockerfile, you might do something like this now:

```
FROM omnibus-trusty:latest

RUN git clone https://github.com/foo/bar.git && cd bar && ln -s /pkg pkg
WORKDIR bar
CMD bundle install --binstubs && bin/omnibus build myproject
```

This is a working example of building the chef-client omnibus packages. Create the following `Dockerfile`

```
FROM omnibus-precise-base:latest

RUN git clone https://github.com/opscode/omnibus-chef.git && cd omnibus-chef && ln -s /pkg pkg
WORKDIR /omnibus-chef
CMD bundle install --binstubs && bin/omnibus build chef
```

then run the following:
```
mkdir pkg
docker build --rm -t omnibus-precise-chefclient .
docker run --rm --name wheezy-nrouter-build -v `pwd`/pkg:/pkg -i -t omnibus-precise-chefclient
```

Your build artifact will be dropped off in the `pkg` directory.

## Credits
This project was inspired by the [http://flapjack.io/docs/1.0/development/Omnibus-In-Your-Docker/](Flapjack project which said they got the toolchain idea from me so who knows.)

Regardless, it's pretty helpful.

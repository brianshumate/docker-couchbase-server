# Docker Couchbase Server

This is a Dockerfile and some supporting bits for running
[Couchbase Server](http://couchbase.com/) in a
[Docker](http://www.docker.io) container.

**NOTE**: *This project is currently being updated to use the new Docker
official Mac OS X support*.

There is a `Vagrantfile` in the `vagrant` directory that is configured to
prepare an Ubuntu 12.04 VirtualBox host for Docker and the requisite bits
needed by Couchbase Server, such as increasing open file limits and locked
memory as detailed below. If you use the supplied `Vagrantfile`, the steps
in the following section will be done for you when you `vagrant up`, and you
will not need to do them by hand.

## Prepare Docker Host

**Note about open file limits and locked memory**: You'll need to increase
the number of open files and locked memory available to Couchbase Server
containers from the Docker host.

To do so, first `ssh` into the Docker host machine and ensure that the
`/etc/init` directory is present:

    sudo mkdir /etc/init

Next, edit `/etc/init/docker.conf`:

    sudo $EDITOR /etc/init/docker.conf

Then, append the following lines to the end of the file:

    limit memlock unlimited unlimited
    limit nofile 262144 262144

You'll need to restart the Docker daemon or host machine after making the
above changes. These changes will affect the Docker daemon and all of its
children, including containers.

To restart the entire Docker host:

    boot2docker restart

Prior to building and running the container, you'll need to prepare a
directory on the Docker host for mapping the Couchbase Server data directory
if you wish to preserve your data through restarts of the image.

First, `ssh` into the Docker host, the execute the following commands:

    sudo mkdir /home/couchbase-server
    sudo chown 999:999 /home/couchbase-server

## Build & Run a Container

Now, you can build and run a Couchbase Server Docker container; be sure to
replace `<yourname>` in the example shown below with your own unique
identifier.

Clone this project into the `/home/docker` directory on the Docker host:

    git clone https://github.com/brianshumate/docker-couchbase-server.git

Then, execute the following commands to build a container:


    cd docker-couchbase-server
    sudo docker build -t <yourname>/couchbase-server .

A command like the following is used to run the container:

    sudo docker run -i -t  -p 11210:11210 -p 8091:8091 -p 8092:8092 \
    <yourname>/couchbase-server

or, if you prefer to have the container run in the background:

    sudo docker run -i -t -d -p 11210:11210 -p 8091:8091 -p 8092:8092 \
    <yourname>/couchbase-server

## Mac OS X Instructions

To use this project on Mac OS X with official Docker support and the
`boot2docker` tool, follow these instructions:

Install the `boot2docker` script with [Homebrew](http://brew.sh/):

    brew install boot2docker

Learn more about Docker Mac OS X support in the
[Mac OS X installation](http://docs.docker.io/en/latest/installation/mac/)
documentation

Once you've installed `boot2docker` you can install the latest Docker 
Mac OS X client with Homebrew:

    brew install docker

Now initialize and boot the Docker daemon and VM:

    boot2docker init
    boot2docker up

Using the Docker client will now work as expected agains the VirtualBox
based VM host:

    docker version

You can also easily ssh into the VM:

    boot2docker ssh

* User name : *root*
* Password  : *tcuser*

Once you've established the Docker host, you can follow the directions under
**Prepare Docker Host** and **Build & Run a Container** to get the project
up and running.


## Resources

The following are some additional handy resources related to operating
Couchbase Server in a Docker environment.

* [Running Couchbase Cluster Under Docker](http://tleyden.github.io/blog/2013/11/14/running-couchbase-cluster-under-docker/)
* [How I built couchbase 2.2 for docker](https://gist.github.com/dustin/6605182)
* [Couchbase Server / Docker Index](https://index.docker.io/u/dustin/couchbase/)

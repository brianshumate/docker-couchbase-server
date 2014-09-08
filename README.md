# Docker Couchbase Server

This is a Dockerfile and supporting scripts for running
[Couchbase Server](http://couchbase.com/) in a
[Docker](http://www.docker.com/) container.


## Prepare Docker Host

If you will be using a CoreOS or Linux based host operating system, there is
a bit of preparation you must do before launching the Couchbase Server
containers.

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

For a Mac OS X host using boot2docker, restart the entire host like this:

    boot2docker restart

## Build & Run a Container

Now, you can build and run a Couchbase Server Docker container; be sure to
replace `<yourname>` in the example shown below with your own unique
identifier.

Clone this project into the `/home/docker` directory on the Docker host:

    git clone https://github.com/brianshumate/docker-couchbase-server.git

Then, execute the following commands to run a container based on this project:

    cd docker-couchbase-server
    INT=`ip route | awk '/^default/ { print $5 }'`
    ADDR=`ip route | egrep "^[0-9].*$INT" | awk '{ print $9 }'`
    exec sudo docker run -i -d -t -e DOCKER_EXT_ADDR=$ADDR \
    -v /home/core/data/couchbase:/opt/couchbase/var \
    -p 11210:11210 -p 8091:7081 -p 8092:8092 \
    brianshumate/couchbase_server

If your Docker host is running CoreOS, use the included `coreos.script`:

    cd docker-couchbase-server
    exec sudo ./bin/coreos.script

## Mac OS X Instructions

Docker is supported on Mac OS X version 10.6 and newer. To learn more about
official Docker Mac OS X support, consult the
[Mac OS X installation](http://docs.docker.io/en/latest/installation/mac/)
documentation.

### Prerequisites

Using Docker and Couchbase Server on OS X requires the free virtual machine
managements software [VirtualBox](https://www.virtualbox.org/). Please ensure
that VirtualBox is installed before proceeding.

### boot2docker

To use this project on a Mac OS X based host, the recommended approach is
to use a [boot2docker](http://boot2docker.io/) TinyCore Linux based
environment by following these instructions:

Install boot2docker script with [Homebrew](http://brew.sh/):

    brew install boot2docker

Once you've installed boot2docker you can install the latest Docker
Mac OS X client with Homebrew:

    brew install docker

Now, initialize and start the Docker virtual machine:

    boot2docker init
    boot2docker start

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


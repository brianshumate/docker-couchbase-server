# Docker Couchbase Server

This is a Dockerfile and supporting scripts for running
[Couchbase Server](http://couchbase.com/) in a
[Docker](http://www.docker.com/) container.

Originally a personal research project, this project has been superseded by
official Docker related resources described below.

**NOTE**: These are official Couchbase Server Docker resources
which you should use instead of this project:

* [Couchbase Docker image on dockerhub](https://hub.docker.com/u/couchbase/server)
* [Dockerfiles and configuration scripts for the Docker Hub Official Couchbase images](https://github.com/couchbase/docker)
* [Run Couchbase Server under Docker + Kubernetes](https://github.com/tleyden/couchbase-kubernetes)
* [Run Couchbase Server under Docker + CoreOS](https://github.com/couchbaselabs/couchbase-server-coreos)

## Prepare Docker Host

Some preparation of the host operating system running the Docker daemon will
be required prior to launching Docker containers. The exact preparation steps
differ depending on the OS distribution.

### Debian, Ubuntu, CentOS or RHEL

**Note about open file limits and locked memory**: You'll need to increase
the number of open files and locked memory available to Couchbase Server
containers on the Docker host.

To do so, first access a shell on the host machine and create the docker
daemon initialization file, `/etc/init/docker.conf`:

```
sudo $EDITOR /etc/init/docker.conf
```

Then add the following lines to the file:

```
limit memlock unlimited unlimited
limit nofile 262144 262144
```

You'll need to restart the Docker daemon after making the above changes. These changes will affect the Docker daemon and all of its child processes,
including containers.

### CoreOS

Information for preparing a CoreOS host system is pending active testing,
and will be forthcoming.

## Run a Couchbase Server Container

Now, you can run a Couchbase Server Docker container.

If you have not already, clone this project repository to your Docker host:

```
git clone https://github.com/brianshumate/docker-couchbase-server.git
```

Then, execute the following commands to run a container based on this project:

```
cd docker-couchbase-server
INT=`ip route | awk '/^default/ { print $5 }'`
ADDR=`ip route | egrep "^[0-9].*$INT" | awk '{ print $9 }'`
exec sudo docker run -i -d -t -e DOCKER_EXT_ADDR=$ADDR \
-v /home/core/data/couchbase:/opt/couchbase/var \
-p 11210:11210 -p 8091:7081 -p 8092:8092 \
brianshumate/couchbase_server
```

If your Docker host is running CoreOS, use the included `coreos.script`:

```
cd docker-couchbase-server
exec sudo ./bin/coreos.script
```

You can also get a 3 node cluster going with the included
`multi-node-cluster` script:

```
cd docker-couchbase-server
exec sudo ./bin/multi-node-cluster
```

## Mac OS X Instructions

Docker is supported on Mac OS X version 10.6 and newer. To learn more about
official Docker Mac OS X support, consult the
[Mac OS X installation](http://docs.docker.io/en/latest/installation/mac/)
documentation.

### Prerequisites

Using Docker and Couchbase Server on OS X with this project requires the free
virtual machine management software [VirtualBox](https://www.virtualbox.org/).
Please ensure that VirtualBox is installed on the host machine
before proceeding with these directions.

### boot2docker

The recommended approach is for using this project on a Mac OS X based host is
to use a [boot2docker](http://boot2docker.io/) TinyCore Linux based
environment by following these steps:

Install boot2docker script with [Homebrew](http://brew.sh/):

```
brew install boot2docker
```

Once you've installed boot2docker you can install the latest Docker
Mac OS X client with Homebrew:

```
brew install docker
```

Now, initialize and start the Docker virtual machine:

```
boot2docker init
boot2docker start
```

Using the Docker client will now work as expected agains the VirtualBox
based VM host:

```
docker version
```

You can also easily ssh into the VM:

```
boot2docker ssh
```

* User name : *root*
* Password  : *tcuser*

Once you've established the Docker host, you can follow the directions under
**Prepare Docker Host** and **Run a Container** sections to get the project
up and running.

## Resources

The following are some additional handy resources related to operating
Couchbase Server in a Docker environment and some were inspirational for this
project. Thanks to these fine folks and their projects:

* [Run Couchbase Server under Docker + CoreOS](https://github.com/couchbaselabs/couchbase-server-docker)
* [Dockerfiles and configuration scripts for the Docker Hub Official Couchbase images](https://github.com/couchbase/docker)
* [Running Couchbase Cluster Under CoreOS on AWS](http://tleyden.github.io/blog/2014/11/01/running-couchbase-cluster-under-coreos-on-aws/)
* [How I built couchbase 2.2 for docker](https://gist.github.com/dustin/6605182)
* [Couchbase Server / Docker Index](https://index.docker.io/u/dustin/couchbase/)
* [Running Couchbase Cluster Under Docker](http://tleyden.github.io/blog/2013/11/14/running-couchbase-cluster-under-docker/)
* [Couchbase Docker container](https://github.com/ncolomer/docker-templates/tree/master/couchbase)

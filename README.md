# Docker Couchbase Server

This is a Dockerfile and some supporting bits for running
[Couchbase Server](http://couchbase.com/) in a 
[Docker](http://www.docker.io) container.

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

To do so, edit `/etc/init/docker.conf` on the Docker host machine, and append
the following line to the end of the file:

```
limit memlock unlimited unlimited
limit nofile 262144 262144
```

You'll need to restart the Docker daemon or host after making the above
changes. The above changes will affect the Docker daemon and all of its
children, including containers.

Prior to building and running the container, you'll need to prepare a
directory on the Docker host for mapping the Couchbase Server data
directory if you wish to preserve your data through restarts of the image.

```
sudo mkdir /home/couchbase-server
sudo chown 999:999 /home/couchbase-server
```

## Build & Run a Container

Now you can build and run a Couchbase Server Docker container; be sure to
replace `<yourname>` in the example shown below with your own unique
identifier.

The following command will build the container:

```
cd docker-couchbase-server
sudo docker build -t <yourname>/couchbase-server .
```

A command like the following is used to run the container:
  
``` 
sudo docker run -i -t  -p 11210:11210 -p 8091:8091 -p 8092:8092 \
<yourname>/couchbase-server
```

or, if you prefer to have the container run in the background:

``` 
sudo docker run -i -t -d -p 11210:11210 -p 8091:8091 -p 8092:8092 \
<yourname>/couchbase-server
```

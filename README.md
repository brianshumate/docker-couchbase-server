docker-couchbase-server
=======================

Dockerfile for [Couchbase Server](http://couchbase.com/) for use with 
[Docker](http://www.docker.io)

**Note about open file limits**: You'll need to increase the number of open
files available to Couchbase Server. The simplest way to do so with Docker is
to edit `/etc/init/docker.conf` on the Docker host machine, and add the
following line right after the *description* line:

```
limit nofile 262144 262144
```

In the Docker host, add the following to `/etc/security/limits.conf`:

```
*                soft    nofile          262144 
*                hard    nofile          262144
```

Then add the following line to `/etc/pam.d/common-session` before the end
of file:

```
session required        pam_limits.so
```

Build a Couchbase Server Docker image:

    cd docker-couchbase-server
    sudo docker build -t="couchbase-server" .

Run and attach to the image:

    sudo docker run -i -t couchbase-server

Or, run image the background

    sudo docker run -d couchbase-server

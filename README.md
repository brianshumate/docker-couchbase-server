# docker-couchbase-server

This is a Dockerfile for running [Couchbase Server](http://couchbase.com/)
in a [Docker](http://www.docker.io) container.

## Prepare Docker Host

**Note about open file limits**: You'll need to increase the number of open
files available to Couchbase Server containers from the Docker host.

To do so, edit `/etc/init/docker.conf` on the Docker host machine, and append
the following line to the end of the file:

    limit nofile 262144 262144

Then, add the following entries to `/etc/security/limits.conf`

    *    hard    nofile    262144
    *    soft    nofile    262144

Finally, add the following line to `/etc/pam.d/common-session`:

    session	required	pam_limits.so

You'll need to restart the Docker host after making the above changes.

## Build & Launch Docker Container

Build a Couchbase Server Docker container:

    cd docker-couchbase-server
    sudo docker build -t="couchbase-server" .

Run and attach to the container:

FIXME: Need a better executable/ENTRYPOINT in these examples here

    sudo docker run -i -t couchbase-server /bin/bash

Or, run container the background

    sudo docker run -d couchbase-server FIXME

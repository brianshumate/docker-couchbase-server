# docker-couchbase-server

This is a Dockerfile for running [Couchbase Server](http://couchbase.com/)
in a [Docker](http://www.docker.io) container.

## Prepare Docker Host

**Note about open file limits**: You'll need to increase the number of open
files available to Couchbase Server containers from the Docker host.

To do so, edit `/etc/init/docker.conf` on the Docker host machine, and append
the following line to the end of the file:

```
limit nofile 262144 262144
```

Then, add the following entries to `/etc/security/limits.conf`

```
*    hard    nofile    262144
*    soft    nofile    262144
```

Finally, add the following line to `/etc/pam.d/common-session`:

```
session	required	pam_limits.so
```

You'll need to restart the Docker host after making the above changes.

## Build & Run Image

Now you can build and run Couchbase Server Docker image; be sure to replace
`<yourname>` in the example shown below with your own unique identifier.

Prepare home directory:

```
mkdir -p /home/couchbase-server
sudo chown 999:999 /home/couchbase-server
```

Build and run the image:

``` 
exec sudo docker run -i -d -t -v /home/couchbase-server:/opt/couchbase/var \
-p 11210:11210 -p 8091:8091 -p 8092:8092 <yourname>/couchbase-server
```

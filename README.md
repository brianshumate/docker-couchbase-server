# docker-couchbase-server

This is a Dockerfile for running [Couchbase Server](http://couchbase.com/)
in a [Docker](http://www.docker.io) container.

## Prepare Docker Host

**Note about open file limits**: You'll need to increase the number of open
files available to Couchbase Server containers from the Docker host.

To do so, edit `/etc/init/docker.conf` on the Docker host machine, and append
the following line to the end of the file:

```
limit memlock unlimited unlimited
limit nofile 262144 262144
```

Then, add the following entries to `/etc/security/limits.conf`

```
*    hard    memlock   unlimited
*    soft    memlock   unlimited
*    hard    nofile    65536
*    soft    nofile    65536
```

Finally, add the following line to `/etc/pam.d/common-session`:

```
session	required	pam_limits.so
```

You'll need to restart the Docker host after making the above changes.

Prior to building and running the container, you'll need to prepare a
directory on the Docker host for mapping the Couchbase Server data
directory if you wish to preserve your data through restarts of the image.

```
sudo mkdir /home/couchbase-server
sudo chown 999:999 /home/couchbase-server
```

**NOTE**: If you use the `Vagrantfile` included in the `vagrant` directory,
the above 2 steps are performed for you when the box is provisioned.

## Build & Run a Container

Now you can build and run a Couchbase Server Docker container; be sure to
replace `<yourname>` in the example shown below with your own unique
identifier.

The following command will build the container:

```
sudo docker build -t <yournmae>/couchbase-server .
```

A command like the following is used to run the container:
  
``` 
sudo docker run -i -t -v /home/couchbase-server:/opt/couchbase/var \
-p 11210:11210 -p 8091:8091 -p 8092:8092 <yourname>/couchbase-server
```

or, if you prefer to have the container run in the background:

``` 
sudo docker run -i -t -d -v /home/couchbase-server:/opt/couchbase/var \
-p 11210:11210 -p 8091:8091 -p 8092:8092 <yourname>/couchbase-server
```

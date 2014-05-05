# Simple Couchbase Server instance
#
# Install Couchbase Server Community Edition (version as per CB_VERSION below)
#
# VERSION 0.9.4

FROM ubuntu
MAINTAINER Brian Shumate, brian@couchbase.com

ENV CB_VERSION 2.2.0
ENV CB_DOWNLOAD_URL http://packages.couchbase.com/releases
ENV CB_PACKAGE couchbase-server-community_$CB_VERSION_x86_64.deb

# Limits
RUN sed -i.bak '/\# End of file/ i\\# Following 4 lines added by docker-couchbase-server' /etc/security/limits.conf
RUN sed -i.bak '/\# End of file/ i\\*                hard    memlock          unlimited' /etc/security/limits.conf
RUN sed -i.bak '/\# End of file/ i\\*                soft    memlock         unlimited\n' /etc/security/limits.conf
RUN sed -i.bak '/\# End of file/ i\\*                hard    nofile          65536' /etc/security/limits.conf
RUN sed -i.bak '/\# End of file/ i\\*                soft    nofile          65536\n' /etc/security/limits.conf
RUN sed -i.bak '/\# end of pam-auth-update config/ i\\# Following line was added by docker-couchbase-server' /etc/pam.d/common-session
RUN sed -i.bak '/\# end of pam-auth-update config/ i\session	required        pam_limits.so\n' /etc/pam.d/common-session

# Locale and supporting utility commands
RUN locale-gen en_US en_US.UTF-8
RUN echo 'root:couchbase' | chpasswd
RUN mkdir -p /var/run/sshd

# Add Universe (for libssl0.9.8 dependency), update & install packages
RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y install librtmp0 libssl0.9.8 lsb-release openssh-server

# Download Couchbase Server package to /tmp & install
ADD $CB_DOWNLOAD_URL/$CB_VERSION/$CB_PACKAGE /tmp/$CB_PACKAGE
RUN dpkg -i /tmp/$CB_PACKAGE

# Open the OpenSSH server and Couchbase Server ports
EXPOSE 22 4369 8091 8092 11209 11210 11211

# couchbase-script approach (thanks for the ideas Dustin!)
VOLUME /home/couchbase-server:/opt/couchbase/var
RUN rm -r /opt/couchbase/var/lib
ADD bin/couchbase-script /usr/local/sbin/couchbase
RUN chmod 755 /usr/local/sbin/couchbase
CMD /usr/local/sbin/couchbase

##############################################################################
# The following bits are for using Couchbase Server with supervisord instead
# NB: This is a WIP and might actually be broken out into a separate file
#     or discarded altogether
##############################################################################
# RUN mkdir -p /var/log/supervisor
# ADD supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# RUN apt-get -y install supervisor
# Stop supervisord
# RUN /etc/init.d/supervisor stop
# Start the supervisord process, thereby also starting Couchbase Server & sshd
# Still working on this; works fine from a shell, but doesn't want to stay
# up on boot
# CMD ["/usr/bin/supervisord"]

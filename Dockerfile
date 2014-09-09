# Install Couchbase Server Community Edition node
# (version as per CB_VERSION variable specified below)
# Based in part on based on work by Dustin Sallings (thank you!):
# https://gist.github.com/dustin/6605182

FROM ubuntu
MAINTAINER Brian Shumate, brian@couchbase.com

ENV CB_VERSION 2.2.0
ENV CB_BASE_URL http://packages.couchbase.com/releases
ENV CB_PACKAGE couchbase-server-community_${CB_VERSION}_x86_64.deb
ENV CB_DOWNLOAD_URL ${CB_BASE_URL}/${CB_VERSION}/${CB_PACKAGE}
ENV CB_LOCAL_PATH /tmp/${CB_PACKAGE}

# User limits
RUN sed -i.bak '/\# End of file/ i\\# Following 4 lines added by docker-couchbase-server' /etc/security/limits.conf
RUN sed -i.bak '/\# End of file/ i\\*                hard    memlock          unlimited' /etc/security/limits.conf
RUN sed -i.bak '/\# End of file/ i\\*                soft    memlock         unlimited\n' /etc/security/limits.conf
RUN sed -i.bak '/\# End of file/ i\\*                hard    nofile          65536' /etc/security/limits.conf
RUN sed -i.bak '/\# End of file/ i\\*                soft    nofile          65536\n' /etc/security/limits.conf
RUN sed -i.bak '/\# end of pam-auth-update config/ i\\# Following line was added by docker-couchbase-server' /etc/pam.d/common-session
RUN sed -i.bak '/\# end of pam-auth-update config/ i\session	required        pam_limits.so\n' /etc/pam.d/common-session

# Locale
RUN locale-gen en_US en_US.UTF-8

# Update & install packages
RUN apt-get -y update
RUN apt-get -y install librtmp0 lsb-release python-httplib2

# Download Couchbase Server package to /tmp & install, stop service
# and remove Couchbase Server lib contents
ADD ${CB_DOWNLOAD_URL} ${CB_LOCAL_PATH}
RUN dpkg -i ${CB_LOCAL_PATH}

# TESTING
#RUN rm ${CB_LOCAL_PATH}
#RUN /etc/init.d/couchbase-server stop
#RUN rm -r /opt/couchbase/var/lib

# FIXME: No longer necessary
# VOLUME /home/couchbase-server:/opt/couchbase/var
RUN rm -r /opt/couchbase/var/lib

# Install Dustin's confsed utility
ADD http://cbfs-ext.hq.couchbase.com/dustin/software/confsed/confsed.lin64.gz /usr/local/sbin/confsed.gz
RUN gzip -d /usr/local/sbin/confsed.gz
RUN chmod 755 /usr/local/sbin/confsed

# Install the Couchbase Server Docker start script
ADD bin/couchbase-script /usr/local/sbin/couchbase
RUN chmod 755 /usr/local/sbin/couchbase

# Open rewritten Couchbase Server administration port and others
# (7081 is rewritten as 8091)
EXPOSE 7081 8092 11210

CMD /usr/local/sbin/couchbase

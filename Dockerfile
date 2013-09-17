# Simple Couchbase Server instance
#
# Install Couchbase Server Community Edition (version as per CB_VERSION below)
#
# VERSION 0.8.1

FROM ubuntu
MAINTAINER Brian Shumate, brian@couchbase.com

ENV CB_VERSION 2.0.1
ENV CB_DOWNLOAD_URL http://packages.couchbase.com/releases
ENV CB_PACKAGE couchbase-server-community_x86_64_$CB_VERSION.deb

# Limits
RUN sed -i.bak '/\# End of file/ i\\# Following 2 lines added by docker-couchbase-server' /etc/security/limits.conf
RUN sed -i.bak '/\# End of file/ i\\*                hard    nofile          262144' /etc/security/limits.conf
RUN sed -i.bak '/\# End of file/ i\\*                soft    nofile          262144\n' /etc/security/limits.conf
RUN sed -i.bak '/\# end of pam-auth-update config/ i\\# Following line was added by docker-couchbase-server' /etc/pam.d/common-session
RUN sed -i.bak '/\# end of pam-auth-update config/ i\session	required        pam_limits.so\n' /etc/pam.d/common-session
  
# Locale and supporting utility commands
RUN locale-gen en_US en_US.UTF-8
RUN echo 'root:couchbase' | chpasswd
RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add Universe (for libssl0.9.8 dependency), update & install packages
RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y install curl libssl0.9.8 lsb-release openssh-server supervisor

# Download the Couchbase Server package
RUN curl -o /tmp/$CB_PACKAGE $CB_DOWNLOAD_URL/$CB_VERSION/$CB_PACKAGE

# Install the Couchbase Server package
RUN dpkg -i /tmp/$CB_PACKAGE

# Open the OpenSSH server and Couchbase Server ports
# Ugly now due to no range, but it's in the works for Docker version 0.8
# See: https://github.com/dotcloud/docker/issues/1834
EXPOSE 4369 8091 8092 11209 11210 11211 21100 21101 21102 21103 21104 21105 21106 21107 21108 21109 21110 21111 21112 21113 21114 21115 21116 21117 21118 21119 21120 21121 21122 21123 21124 21125 21126 21127 21128 21129 21130 21131 21132 21133 21134 21135 21136 21137 21138 21139 21140 21141 21142 21143 21144 21145 21146 21147 21148 21149 21150 21151 21152 21153 21154 21155 21156 21157 21158 21159 21160 21161 21162 21163 21164 21165 21166 21167 21168 21169 21170 21171 21172 21173 21174 21175 21176 21177 21178 21179 21180 21181 21182 21183 21184 21185 21186 21187 21188 21189 21190 21191 21192 21193 21194 21195 21196 21197 21198 21199

# The initctl workaround
# See: https://github.com/dotcloud/docker/issues/1024
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

# Start the supervisord process, thereby also starting Couchbase Server & sshd
# Still working on this; works fine from a shell, but doesn't want to stay
# up on boot
CMD ["/usr/bin/supervisord"]
CMD ["/bin/bash"]

# Simple Couchbase Server installation
#
# Currently installs Couchbase Server Community Edition version 2.0.1
#
# VERSION 0.3

FROM ubuntu
MAINTAINER Brian Shumate, brian@couchbase.com

ENV CB_DOWNLOAD_URL http://packages.couchbase.com/releases
ENV CB_VERSION 2.0.1
ENV CB_PACKAGE couchbase-server-community_x86_64_$CB_VERSION.deb
ENV UNIVERSE_URL deb http://us.archive.ubuntu.com/ubuntu/ precise universe

# Limits
RUN echo '* hard nofile 262144' >> /etc/security/limits.conf
RUN echo '* soft nofile 262144' >> /etc/security/limits.conf
RUN echo 'session	required	pam_limits.so' >> /etc/pam.d/common-session

# Add Universe (for libssl0.9.8), update & install packages
RUN echo $UNIVERSE_URL >> /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y install libssl0.9.8 wget

# Download the Couchbase Server package
RUN wget -O /tmp/$CB_PACKAGE $CB_DOWNLOAD_URL/$CB_VERSION/$CB_PACKAGE

# Install the Couchbase Server package
RUN dpkg -i /tmp/$CB_PACKAGE

# Open Couchbase Server ports (would be nice to have range support for EXPOSE)
EXPOSE 4369 8091 8092 11209 11210 11211 21100 21101 21102 21103 21104 21105 21106 21107 21108 21109 21110 21111 21112 21113 21114 21115 21116 21117 21118 21119 21120 21121 21122 21123 21124 21125 21126 21127 21128 21129 21130 21131 21132 21133 21134 21135 21136 21137 21138 21139 21140 21141 21142 21143 21144 21145 21146 21147 21148 21149 21150 21151 21152 21153 21154 21155 21156 21157 21158 21159 21160 21161 21162 21163 21164 21165 21166 21167 21168 21169 21170 21171 21172 21173 21174 21175 21176 21177 21178 21179 21180 21181 21182 21183 21184 21185 21186 21187 21188 21189 21190 21191 21192 21193 21194 21195 21196 21197 21198 21199

# USER couchbase

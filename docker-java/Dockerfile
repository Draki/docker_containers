FROM ubuntu:bionic

# Users with other locales should set this in their derivative image
RUN apt-get update -qq \
 && apt-get install -y locales \
 && dpkg-reconfigure -f noninteractive locales \
 && locale-gen en_US.UTF-8 \
 && /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


# Ugrade OS, install wget and clean auxiliar folders
RUN apt-get upgrade -y -qq \
    && apt-get install -q -y --no-install-recommends wget openssh-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# JAVA
ARG JAVA_MAJOR_VERSION=8
ARG JAVA_UPDATE_VERSION=191
ARG JAVA_BUILD_NUMBER=12
ARG JAVA_VERSION_TOKEN=2787e4a523244c269598db4e85c51e0c

ENV JAVA_VERSION jdk1.${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-b${JAVA_BUILD_NUMBER}
ENV JAVA_HOME /usr/jdk1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION}
ENV PATH $PATH:$JAVA_HOME/bin

RUN mkdir $JAVA_HOME \
    && wget --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" -qO- \
    http://download.oracle.com/otn-pub/java/jdk/${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-b${JAVA_BUILD_NUMBER}/${JAVA_VERSION_TOKEN}/server-jre-${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-linux-x64.tar.gz \
    | tar zxf - -C ${JAVA_HOME} --strip 1 \
    && ln -s $JAVA_HOME /usr/java \
    && rm -rf $JAVA_HOME/man

# USER SETUP
ENV USER_NAME danielrodriguez
RUN useradd -m -s /bin/bash $USER_NAME
WORKDIR /home/$USER_NAME

# SSH SETUP
RUN mkdir /home/$USER_NAME/.ssh
RUN echo PubkeyAcceptedKeyTypes +ssh-dss >> /home/$USER_NAME/.ssh/config
RUN echo PasswordAuthentication no >> /home/$USER_NAME/.ssh/config

COPY config/id_rsa.pub /home/$USER_NAME/.ssh/id_rsa.pub
COPY config/id_rsa /home/$USER_NAME/.ssh/id_rsa
RUN cat /home/$USER_NAME/.ssh/id_rsa.pub >> /home/$USER_NAME/.ssh/authorized_keys
RUN chown -R ${USER_NAME} /home/$USER_NAME/.ssh
RUN chmod 400 /home/$USER_NAME/.ssh/id_rsa

RUN echo PubkeyAuthentication yes >> /etc/ssh/ssh_config
RUN echo Host * >> /etc/ssh/ssh_config
RUN service ssh start
CMD service ssh start && bash


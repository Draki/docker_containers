#modificar al subirlo al registry
FROM danielrodriguez/oraclejava:8u191-b12

EXPOSE 22/tcp
EXPOSE 22/udp
#
ENV USER_NAME danielrodriguez
#RUN useradd -m -s /bin/bash $USER_NAME
#
#RUN mkdir /home/$USER_NAME/.ssh
#RUN echo PubkeyAcceptedKeyTypes +ssh-dss >> /home/$USER_NAME/.ssh/config
#RUN echo PasswordAuthentication no >> /home/$USER_NAME/.ssh/config
#
#COPY config/id_rsa.pub /home/$USER_NAME/.ssh/id_rsa.pub
#COPY config/id_rsa /home/$USER_NAME/.ssh/id_rsa
#RUN cat /home/$USER_NAME/.ssh/id_rsa.pub >> /home/$USER_NAME/.ssh/authorized_keys
#RUN chown -R ${USER_NAME} /home/$USER_NAME/.ssh
#RUN chmod 400 /home/$USER_NAME/.ssh/id_rsa


# HADOOP
ENV HADOOP_VERSION 3.1.1
ENV HADOOP_HOME /usr/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

RUN mkdir $HADOOP_HOME \
    && wget http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz -qO-\
    | tar zxf - -C ${HADOOP_HOME} --strip 1 \
    && rm -rf $HADOOP_HOME/share/doc

RUN chown -R $USER_NAME $HADOOP_HOME \
    && ln -s $HADOOP_HOME /home/$USER_NAME/hadoop
      

RUN mkdir -p $HADOOP_HOME/data/nameNode $HADOOP_HOME/data/dataNode $HADOOP_HOME/data/namesecondary $HADOOP_HOME/data/tmp
RUN chown $USER_NAME $HADOOP_HOME/data/nameNode $HADOOP_HOME/data/dataNode $HADOOP_HOME/data/namesecondary $HADOOP_HOME/data/tmp

RUN echo JAVA_HOME=$JAVA_HOME >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
RUN echo HDFS_NAMENODE_USER=$USER_NAME >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
RUN echo HDFS_DATANODE_USER=$USER_NAME >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
RUN echo HDFS_SECONDARYNAMENODE_USER=$USER_NAME >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

COPY config/core-site.xml config/hdfs-site.xml config/mapred-site.xml config/yarn-site.xml $HADOOP_HOME/etc/hadoop/
RUN chown $USER_NAME $HADOOP_HOME/etc/hadoop/*


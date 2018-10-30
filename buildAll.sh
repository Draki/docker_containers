#!/usr/bin/env bash

DOCKER_ID_USER=danielrodriguez

JAVA_MAJOR_VERSION=8
JAVA_UPDATE_VERSION=191
JAVA_BUILD_NUMBER=12
JAVA_VERSION=${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-b${JAVA_BUILD_NUMBER}
HADOOP_VERSION='3.1.1'
SPARK_VERSION='2.3.2'

#echo "Y" | ssh-keygen -t rsa -P '' -f docker-java/config/id_rsa

docker build ./docker-java/ -t ${DOCKER_ID_USER}/oraclejava:${JAVA_VERSION}
docker push ${DOCKER_ID_USER}/oraclejava:${JAVA_VERSION}
docker build ./docker-hadoop/ -t ${DOCKER_ID_USER}/hadoop:${HADOOP_VERSION}
docker push ${DOCKER_ID_USER}/hadoop:${HADOOP_VERSION}
docker build ./docker-spark/ -t ${DOCKER_ID_USER}/spark:${SPARK_VERSION}
docker push ${DOCKER_ID_USER}/spark:${SPARK_VERSION}

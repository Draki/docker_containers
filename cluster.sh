#!/bin/bash

# Bring the services up
function startServices {
  docker start spark-master node2 node3
  sleep 5
  echo ">> Starting hdfs ..."
  docker exec -u danielrodriguez -it spark-master hadoop/sbin/start-dfs.sh
  sleep 5
  echo ">> Starting yarn ..."
  docker exec -u danielrodriguez -d spark-master hadoop/sbin/start-yarn.sh
  sleep 5
  echo ">> Starting Spark ..."
  docker exec -u danielrodriguez -d spark-master /home/danielrodriguez/sparkcmd.sh start
  docker exec -u danielrodriguez -d node2 /home/danielrodriguez/sparkcmd.sh start
  docker exec -u danielrodriguez -d node3 /home/danielrodriguez/sparkcmd.sh start
  echo "Hadoop info @ nodemaster: http://172.18.1.1:8088/cluster"
  echo "Spark info @ nodemater  : http://172.18.1.1:8080/"
}

if [[ $1 = "start" ]]; then
  startServices
  exit
fi

if [[ $1 = "stop" ]]; then
  docker exec -u danielrodriguez -d spark-master /home/danielrodriguez/sparkcmd.sh stop
  docker exec -u danielrodriguez -d node2 /home/danielrodriguez/sparkcmd.sh stop
  docker exec -u danielrodriguez -d node3 /home/danielrodriguez/sparkcmd.sh stop
  docker stop spark-master node2 node3
  exit
fi

if [[ $1 = "deploy" ]]; then
  docker rm -f `docker ps -aq` # delete old containers
  docker network rm daninet
  docker network create --subnet=172.18.0.0/16 daninet # create custom network

  # 3 nodes
  echo ">> Starting nodes master and worker nodes ..."
  docker run -d --net daninet --ip 172.18.1.1 --hostname spark-master --add-host node2:172.18.1.2 --add-host node3:172.18.1.3 --name nodemaster -it danielrodriguez/spark:2.3.2
  docker run -d --net daninet --ip 172.18.1.2 --hostname node2  --add-host nodemaster:172.18.1.1 --add-host node3:172.18.1.3 --name node2 -it danielrodriguez/spark:2.3.2
  docker run -d --net daninet --ip 172.18.1.3 --hostname node3  --add-host nodemaster:172.18.1.1 --add-host node2:172.18.1.2 --name node3 -it danielrodriguez/spark:2.3.2

  # Format nodemaster
  echo ">> Formatting hdfs ..."
  docker exec -u danielrodriguez -it spark-master hadoop/bin/hdfs namenode -format
  startServices
  exit
fi

echo "Usage: cluster.sh deploy|start|stop"
echo "                 deploy - create a new Docker network"
echo "                 start  - start the existing containers"
echo "                 stop   - stop the running containers"  

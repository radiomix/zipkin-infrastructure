#!/bin/bash

#
# Run all neccessary Docker container to run a zipkin tracing/logging app:
# Usage: ./deploy.sh      		--> runs zipkin containers and connects ports 
# 	 ./deploy.sh  -c|--cleanup  	--> removes old containers; runs zipkin containers and connects ports 
#
#TODO: The second run needs to remove old containers; 
# If not, docker will complain about the container
# container name beeing allready assigned.
# 

source ./utils.sh
 
# How we call the containers
IMG_PREFIX="elemica/zipkin-"

#Container name prefix
NAME_PREFIX="zipkin-"

# registry and port, we push to 
# my-registry.example.com:5000/  !! TRAILING FORWARDSLASH !! 
REGISTRY_URL=registry.im7.de:5000/ 

#Ports to be exposed between the containers
WEB_PORT="8080"
COLLECTOR_PORT="9410"
COLLECTOR_MGT_PORT="9900"
QUERY_PORT="9411"

ROOT_URL="http://deb.local:$PUBLIC_PORT"

#All containers
SERVICES=("cassandra" "collector" "query" "web" "fb-scribe")

# test for input parameter
# ----------------------------------------------------------- #
case "$1" in
# ----------------------------------------------------------- #
 -h|--help)
  echo "
 usage: 
	:>deploy               	starts all containers
	:>deploy -s|--stop 	stop old containers
	:>deploy -c|--cleanup	stop and remove old containers
	:>deploy -h|--help 	this message
       
      "
  exit
	;;

# ----------------------------------------------------------- #
 -s|--stop)
  echo " Stopping old services  "
  RUNNING=0
  for i in "${SERVICES[@]}"; do
    echo "** Stopping zipkin-$i"
    sudo docker stop "${NAME_PREFIX}$i" &>/dev/null	#redirect stdout&stderror 
    sudo docker ps -a | grep Exited  | grep $IMG_PREFIX &>/dev/null
    if [ $? -eq 0  ]
    then 
	(( RUNNING += 1 ))
    fi
  done
    if [ $RUNNING -ne 0 ] 
    then
      echo "** These containers are in the way "
      echo "** "
      sudo docker ps -a | grep Exited 
      echo "** "
      echo "** You can remove all containers by issuning command"
      echo "** ./deploy.sh --cleanup"
    fi
    echo "** EXIT "
    exit 
	;;
# ----------------------------------------------------------- #
 -c|--cleanup)
  echo " Cleaning up old services  "
  for i in "${SERVICES[@]}"; do
    echo "** Stopping zipkin-$i"
    sudo docker stop "${NAME_PREFIX}$i" &>/dev/null	#redirect stdout&stderror 
    echo "** Removing zipkin-$i"
    sudo docker rm "${NAME_PREFIX}$i"   &>/dev/null     
  done
    sudo docker ps | grep Exited
    exit 
	;;
esac



# ----------------------------------------------------------- #
  # first we inspect which containers are running
  for i in "${SERVICES[@]}"; do
    sudo docker ps  | grep Up | grep "${NAME_PREFIX}$i"
    if [ $? == "0" ]
    then
       echo  "** Please stop container ${NAME_PREFIX}$i by issuing command
** sudo docker kill ${NAME_PREFIX}$i"
       echo "**  EXIT"
       exit 100
    fi
  done
  # than we inspect which containers are named allready
  for i in "${SERVICES[@]}"; do
    sudo docker ps  -a | grep Exited | grep "${NAME_PREFIX}$i"
    if [ $? == "0" ]
    then
       echo  "** Please remove container ${NAME_PREFIX}$i by issuing command
** sudo docker rm ${NAME_PREFIX}$i"
       echo "**  EXIT"
       exit 100
    fi
  done 


# ----------------------------------------------------------- #
echo "** Starting zipkin-cassandra"
  sudo docker run -d --name="${NAME_PREFIX}cassandra" "${IMG_PREFIX}cassandra" #&>/dev/null
  sudo docker logs "${NAME_PREFIX}cassandra" | tail -5

echo "** Starting zipkin-collector"
sudo docker run -d --link="${NAME_PREFIX}cassandra:db" -p 9410:$COLLECTOR_PORT -p 9900:$COLLECTOR_MGT_PORT --name="${NAME_PREFIX}collector" "${IMG_PREFIX}collector"

echo "** Starting zipkin-query"
sudo docker run -d --link="${NAME_PREFIX}cassandra:db" -p 9411:$QUERY_PORT --name="${NAME_PREFIX}query" "${IMG_PREFIX}query"

echo "** Starting zipkin-web"
sudo docker run -d --link="${NAME_PREFIX}query:query" -p 8080:$WEB_PORT -e "ROOTURL=${ROOT_URL}" --name="${NAME_PREFIX}web" "${IMG_PREFIX}web"

echo "** Starting zipkin-fb-scribe"
sudo docker run -d --link="${NAME_PREFIX}query:query" -p 8080:$WEB_PORT -e "ROOTURL=${ROOT_URL}" --name="${NAME_PREFIX}fb-scribe" "${IMG_PREFIX}fb-scribe" /bin/bash


echo "** Done Starting container "
sudo docker ps -a
for i in "{SERVICE[@]}"; do
 sudo docker logs "${NAME_PREFIX}$i" | tail -5
done

exit

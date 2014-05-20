#!/bin/bash

#
# Run all neccessary Docker container to run a zipkin tracing/logging app:
# Usage: ./deploy.sh      --> runs zipkin containers and connects ports 
# 	 ./deploy.sh  -y  --> removes old containers; runs zipkin containers and connects ports 
#
# Second run needs option -y, to remove old containers; 
# If not, docker will complain about the container
# container name beeing allready assigned.
# 
 
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


#TODO Read option string and jump if
#if [[ $CLEANUP == "-y" ]]; then
  SERVICES=("cassandra" "collector" "query" "web" "fb-scribe")
  for i in "${SERVICES[@]}"; do
    echo "** Stopping zipkin-$i"
    sudo docker stop "${NAME_PREFIX}$i"
    sudo docker rm "${NAME_PREFIX}$i"
  done
#fi

echo "** TESTING BASE "
sudo docker run -d --name="${NAME_PREFIX}base" "${IMG_PREFIX}base"

echo "** TESTING SCRIBE"
sudo docker run -d --name="${NAME_PREFIX}fb-scribe" "${IMG_PREFIX}fb-scribe"

echo "** END TESTING **"
sudo docker ps 
sudo docker ps -a

exit
#TODO REMOVE TEST

echo "** Starting zipkin-cassandra"
echo docker run -d --name="${NAME_PREFIX}cassandra" "${IMG_PREFIX}cassandra"

echo "** Starting zipkin-collector"
echo docker run -d --link="${NAME_PREFIX}cassandra:db" -p 9410:$COLLECTOR_PORT -p 9900:$COLLECTOR_MGT_PORT --name="${NAME_PREFIX}collector" "${IMG_PREFIX}collector"

echo "** Starting zipkin-query"
echo docker run -d --link="${NAME_PREFIX}cassandra:db" -p 9411:$QUERY_PORT --name="${NAME_PREFIX}query" "${IMG_PREFIX}query"

echo "** Starting zipkin-web"
echo sudo docker run -d --link="${NAME_PREFIX}query:query" -p 8080:$WEB_PORT -e "ROOTURL=${ROOT_URL}" --name="${NAME_PREFIX}web" "${IMG_PREFIX}web"

echo "** Starting zipkin-fb-scribe"
echo docker run -d --link="${NAME_PREFIX}query:query" -p 8080:$WEB_PORT -e "ROOTURL=${ROOT_URL}" --name="${NAME_PREFIX}fb-scribe" "${IMG_PREFIX}fb-scribe"


exit


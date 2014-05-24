#!/bin/bash

source ./utils.sh

CONTAINER_VERSION=$VERSION_LATEST

# test for input parameter
case "$1" in
# ----------------------------------------------------------- #
 -l|--latest)
	CONTAINER_VERSION=$VERSION_LATEST
	;;
# ----------------------------------------------------------- #
 -m|--minus_one)
	CONTAINER_VERSION=$VERSION_PREVIOUS
	;;
# ----------------------------------------------------------- #
 -h|--help|*)
  echo "
 usage: 
start.sh  --latest      start all containers tagged as latest
start.sh  --minus_one   start all containers tagged as minus_one 
start.sh -h|--help      this message
      "
  exit
	;;
esac
echo "**  Using container version: $CONTAINER_VERSION" 
# first we inspect which containers are running
# ----------------------------------------------------------- #
  for i in "${SERVICES[@]}"; do
    docker ps  | grep Up | grep "${NAME_PREFIX}$i"
    if [ $? == "0" ]
    then
       echo  "** Please stop container ${NAME_PREFIX}$i by issuing command
** docker kill ${NAME_PREFIX}$i"
       echo "**  EXIT"
       exit 100
    fi
  done
# than we inspect which containers are named allready
# ----------------------------------------------------------- #
  for i in "${SERVICES[@]}"; do
    docker ps  -a | grep Exited | grep "${NAME_PREFIX}$i"
    if [ $? == "0" ]
    then
      echo  "** Please commit and remove container ${NAME_PREFIX}$i by issuing command"
      echo "** docker commit  ${NAME_PREFIX}$i ${IMG_PREFIX}$i:TAG_NAME"
      echo "** docker rm ${NAME_PREFIX}$i"
      echo "**  EXIT"
      exit 100
    fi
  done






# ----------------------------------------------------------- #
# Start all containers in $SERVICES
# We expect them to be down!
# ----------------------------------------------------------- #
  echo "** Starting zipkin-cassandra"
  docker run -d --name="${NAME_PREFIX}cassandra" "${IMG_PREFIX}cassandra" #&>/dev/null

  echo "** Starting zipkin-collector"
  docker run -d --link="${NAME_PREFIX}cassandra:db" -p 9410:$COLLECTOR_PORT -p 9900:$COLLECTOR_MGT_PORT --name="${NAME_PREFIX}collector" "${IMG_PREFIX}collector"

  echo "** Starting zipkin-query"
  docker run -d --link="${NAME_PREFIX}cassandra:db" -p 9411:$QUERY_PORT --name="${NAME_PREFIX}query" "${IMG_PREFIX}query"

  echo "** Starting zipkin-web"
  docker run -d --link="${NAME_PREFIX}query:query" -p 8080:$WEB_PORT -e "ROOTURL=${ROOT_URL}" --name="${NAME_PREFIX}web" "${IMG_PREFIX}web"

  echo "** Starting zipkin-fb-scribe"
  docker run -d --link="${NAME_PREFIX}query:query" -p 8080:$WEB_PORT -e "ROOTURL=${ROOT_URL}" --name="${NAME_PREFIX}fb-scribe" "${IMG_PREFIX}fb-scribe" /bin/bash


  echo "** Done Starting container "
  for i in "${SERVICES[@]}"; do
    echo
    UP=$(docker ps -a | grep Up | grep " ${NAME_PREFIX}$i")
    if  [ -n "$UP"  ]
    then
      echo "** Container ${NAME_PREFIX}$i Up"
     else 
     echo "** ERROR: Container  ${NAME_PREFIX}$i NOT RUNNING!! "
  fi
  done
  docker ps  -a



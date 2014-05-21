#!/bin/bash

source ./utils.sh



# test for input parameter
case "$1" in
# ----------------------------------------------------------- #
 -h|--help)
# ----------------------------------------------------------- #
  echo "
 usage: 
	:>start.sh       	        start all containers
 	:>start.sh container 	start this container
 	:>start.sh -h|--help 	this message
       
      "
  exit
	;;
# ----------------------------------------------------------- #
  *)  #We expect this to be a container
# ----------------------------------------------------------- #
##TODO check if input is a valuable container name
   if [ ${#1} -gt 0  ]  #strlen $1 (first parameter)
   then
     SERVICES=("$1") 
   fi
   ;;
esac



# first we inspect which containers are running
# ----------------------------------------------------------- #
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
# ----------------------------------------------------------- #
  for i in "${SERVICES[@]}"; do
    sudo docker ps  -a | grep Exited | grep "${NAME_PREFIX}$i"
    if [ $? == "0" ]
    then
      echo  "** Please remove container ${NAME_PREFIX}$i by issuing command"
      echo "** sudo docker rm ${NAME_PREFIX}$i"
      echo "**  EXIT"
      exit 100
    fi
  done






# ----------------------------------------------------------- #
# Start all containers
# We expect them to be down!
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
  for i in "${SERVICES[@]}"; do
    echo
    UP=$(sudo docker ps -a | grep Up | grep " ${NAME_PREFIX}$i")
    if  [ -n "$UP"  ]
    then
      echo "** LAST LOG FOR  ${NAME_PREFIX}$i"
      sudo docker logs "${NAME_PREFIX}$i" | tail -5
    else 
     echo "** ERROR: Container  ${NAME_PREFIX}$i NOT RUNNING!! "
  fi
  done
  sudo docker ps  -a



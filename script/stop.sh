#!/bin/bash

#
# Run all neccessary Docker container to run a zipkin tracing/logging app:
# Usage: ./stop.sh      		--> runs zipkin containers and connects ports 
# 	 ./stop.sh  -c|--cleanup  	--> stops and removes old containers; 
# 	 ./stop.sh  -s|--stop 	--> stop old containers; 
#
# The second run needs to remove old containers; 
# If not, docker will complain about the container
# container name beeing allready assigned.
# 


## this file contains configuration and functions
source ./utils.sh
 
# test for input parameter
case "$1" in

# ----------------------------------------------------------- #
 -c|--cleanup)
# ----------------------------------------------------------- #
  echo " Cleaning up  services  "
   LOGDATE="$(date '+%F-%M-%S')"
  for i in "${SERVICES[@]}"; do
    echo "** Commiting  zipkin-$i to ${IMG_PREFIX}$i:$LOGDATE"
    ##TODO chef if container exists and then commit
    sudo docker commit "${NAME_PREFIX}$i ${IMG_PREFIX}$i:$LOGDATE" #&>/dev/null	#redirect stdout&stderror 
    echo "** Stopping zipkin-$i"
    sudo docker stop "${NAME_PREFIX}$i" &>/dev/null	#redirect stdout&stderror 
    echo "** Removing zipkin-$i"
    sudo docker rm "${NAME_PREFIX}$i"   &>/dev/null     
  done
    sudo docker images | grep $LOGDATE
    exit 
	;;
# ----------------------------------------------------------- #
 -s|--stop)
# ----------------------------------------------------------- #
    echo " Stopping  services  "
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
      echo "** ./stop.sh --cleanup"
    fi
    echo "** EXIT "
    exit 
	;;
# ----------------------------------------------------------- #
 -h|--help|*)
# ----------------------------------------------------------- #
  echo "
 usage: 
	:>stop.sh -s|--stop     stop all containers
	:>stop.sh -s|--cleanup	stop and remove old containers
 	:>stop.sh -h|--help 	this message
       
      "
  exit
	;;
esac

exit 0

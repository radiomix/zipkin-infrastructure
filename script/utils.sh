#!/bin/bash

#
# Configuration
#
source ./config.sh

# ----------------------------------------------------------- #
#
# Functions to be used with docker
#
#

# ----------------------------------------------------------- #
# use this to extract a container ID if the name
# of the container is passed
# ----------------------------------------------------------- #
getContainerIdByName(){
 if [ -z "$1" ]                           # Is parameter #1 zero length?
   then
     echo " ERROR: Missing container name. "
     exit 100
 fi

 RESULT=/tmp/result.txt
 docker inspect $1  | grep ID > $RESULT 2>/dev/null
 sed -e 's/"ID": "//' -i $RESULT                       #remove the ID tag
 sed -e 's/"ContainerIDFile": "//' -i $RESULT          #remove the ContainerIdFile tag
 sed -e 's/",//g' -i $RESULT                           #remove the comma
 sed -e 's/ //g' -i $RESULT                            #remove white space
 sed -e '2d'  -i $RESULT                               #remove white space
 CONTAINER_ID=$(cat $RESULT) 
return  #$CONTAINER_ID
}


# ----------------------------------------------------------- #
# Stops a container
# Expects a paramater: either container name or container id
# ----------------------------------------------------------- #
stopContainer() {
  if [ -z "$1" ]                           # Is parameter #1 zero length?
     then
     echo " ERROR: Missing container . "
     return 100
   fi
   echo "** Stoping Container $1"
   docker stop $1 &>/dev/null
   if [ $? == 0 ]
   then
     docker ps -a | grep Exited | grep $1
     return 0
   else 
     getContainerIdByName $1
     docker stop $CONTAINER_ID 
   fi 
  docker ps -a | grep Exited | grep $CONTAINER_ID
  
}



#echo "## TESTING ## REMOVE ME!! in $0 "
#NAME=zipkin-web
#stopContainer $NAME


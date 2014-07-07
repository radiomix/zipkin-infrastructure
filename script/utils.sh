#!/bin/bash

#
# Configuration
#
source ./config.sh


# We save input parameters for further usage
#The image name
image=$1
#The docker key
key=$2

# ----------------------------------------------------------- #
# Wrapper to test, if the string is a known zipkin service, 
# return true if known, otherwise return false.
# Expects a string as input parameter and global SERVICES as an array
# ----------------------------------------------------------- #
isZipkinService () {
  local one=$image
  local two=${SERVICES[@]}
  if isElementInArray "$one" "$two"; then return 0; else return 1; fi
}

# ----------------------------------------------------------- #
# Wrapper to test, if the string is a known docker inspect key, 
# return true if known, otherwise return false.
# Expects a string as input parameter and global DOCKER_INSPECT as an array
# ----------------------------------------------------------- #
isDockerKey() {
  local one=$key
  local two=${DOCKER_INSPECT[@]}
  if isElementInArray "$one" "$two"; then return 0; else return 1; fi
}

# ----------------------------------------------------------- #
# Checks if an element is whithin an array. 
# Returns 0 if element is wihtin the array and 1 otherwise. 
# Expects two parameter:
#  $one: string " some string"
#  $two: array as "${array[@]}" 
# Usage:
# $:> if isElementInArray " some string" "${array[@]}"; then do this else do that; fi
# http://stackoverflow.com/questions/3685970/check-if-an-array-contains-a-value
# ----------------------------------------------------------- #
isElementInArray() {
if [ -z $one ]
 then
 echo "ERROR: empty parameter"
 echo "usage: isElementInArray '"foo'" '"${bar[@]}'"
 return 1 
fi

##echo "in isElement $one; $two "
local element
for element in $two; 
do
  #echo "$element==$one" 
  [[ "$element" == "$one" ]] && return 0; 
done
return 1
}


# ----------------------------------------------------------- #
# Echo help message, how to use the scripts in this direcotry
# by providing a known zipkin service
# ----------------------------------------------------------- #
showUsage() {
  echo "** ERROR :$2: NO Zipkin Service"
  echo "** please provide a valid Zipkin Service: "
  echo "** ${SERVICES[@]}"
  echo "Usage:"
  for service in ${SERVICES[@]}; do
    echo " $1 $service "
  done
  echo "** EXIT ";
}
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


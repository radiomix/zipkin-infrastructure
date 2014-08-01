#!/bin/bash

#
# Configuration
#
# How we call the containers
IMG_PREFIX="elemica/zipkin-"  

#Container name prefix
NAME_PREFIX="zipkin-"

# Directory with zipkin docker files
DOCKERDIR=""
if [ ${DIRNAME} == "script" ] 
then
  DOCKERDIR="../"
fi
#echo "#$DOCKERDIR#"
# registry and port, we push to 
# my-registry.example.com:5000/  !! TRAILING FORWARDSLASH !! 
REGISTRY_URL=registry.elemica.com:5000/  
 
######################################
#Ports to be exposed between the containers
WEB_PORT="8080"
COLLECTOR_PORT="9410"
COLLECTOR_MGT_PORT="9900"
QUERY_PORT="9411"
PRIVATE_SERVER_IP=$(hostname -i)
##FIXME http://localhost:$PUBLIC_PORT
#ROOT_URL="http://deb.local:$PUBLIC_PORT"
ROOT_URL="http://$PRIVATE_SERVER_IP:$WEB_PORT"
FB_SCRIBE_PORT="1463"

######################################
#All containers
SERVICES=("base" "cassandra" "collector" "query" "web" "fb-scribe")
#All zipkin containers
ZIPKIN_SERVICES=("cassandra" "collector" "query" "web")
#fb scribe client container
SCRIBE_SERVICES=("fb-scribe")

#Author
AUTHOR="Elemica Script"

######################################
#Container versions to revert between latest and minus_one
VERSION_LATEST="latest"
VERSION_PREVIOUS="minus_one"

######################################
# LOGGING
#Log date, may be used to tag current container before pulling new one
LOGDATE=$(date '+%F-%H-%M-%S')
#
#Log directory: if we were called from within dir script, one dir up!
#
if [ ${DIRNAME} == "script" ] 
then
  LOGDIR=$(pwd)/log/
else
 echo "** ERROR LOGDIR:$LOGDIR: not defined"
 exit 100
fi
# Logfile name
LOGFILE=$LOGDIR$NAME_PREFIX"docker.log"
######################################
# inspecting docker containers/images
# We declare an array containg each docker json KEY to be searched by 
# :> docker inspect -f"{{.KEY}}" CONTAINERID
DOCKER_INSPECT=("Args" "Architecture" "Author" "Comment" "Config" "Container" "Created" "DockerVersion" "Driver" "Env" "ExecDriver" "HostConfig"  "HostnamePath"  "HostsPath" "Id"  "Image"   "MountLabel"  "Name"  "NetworkSettings"  "Os"  "Parent" "Path" "ProcessLabel" "ResolvConfPath" "Size" "State" "Volumes" "VolumesRW")

######################################
# SILENT=true   dont output anything
# To run without logging into $LOGFILE uncomment next line  
#SILENT=true


######################################
# down here, nothing to be changed
######################################
if [ $SILENT ] 
then 
    echo "** CAUTION: ACTIONS ARE NOT LOGGED into $LOGFILE"
    echo "** TO LOG INTO  $LOGFILE COMMENT OUT VARIABLE $SILENT IN \"config.sh\" "
    sleep 3
    LOGFILE="/dev/null"
fi


echo "** Executing: \"$0\" Parameter: \"$*\" User: \"$(whoami)\"" 
echo "** Logging into $LOGFILE"
# First two lines in logfile:
echo "#####################################"   &>> $LOGFILE
date &>> $LOGFILE
echo "** Executing script: \"$0\" Parameter: \"$*\" User: \"$(whoami)\"" &>> $LOGFILE


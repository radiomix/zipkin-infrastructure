#!/bin/bash

#
# Configuration
#
# How we call the containers
IMG_PREFIX="elemica/zipkin-"  L

#Container name prefix
NAME_PREFIX="zipkin-"

# registry and port, we push to 
# my-registry.example.com:5000/  !! TRAILING FORWARDSLASH !! 
REGISTRY_URL=registry.elemica.com:5000/  
 
######################################
#Ports to be exposed between the containers
WEB_PORT="8080"
COLLECTOR_PORT="9410"
COLLECTOR_MGT_PORT="9900"
QUERY_PORT="9411"

ROOT_URL="http://deb.local:$PUBLIC_PORT"

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
#Log directory
LOGDIR=../log/
# Logfile name
LOGFILE=$LOGDIR$NAME_PREFIX"docker.log"
######################################
# SILENT=true   dont output anything
# To run without logging int $LOGFILE uncomment next line  
#SILENT=true



######################################
# down here, nothing to be changed
######################################
if [ $SILENT ] 
then 
    echo "CAUTION: ACTIONS ARE NOT LOGGED into $LOGFILE"
    echo "TO LOG INTO  $LOGFILE COMMENT OUT VARIABLE $SILENT IN \"config.sh\" "
    sleep 3
    LOGFILE="/dev/null"
fi


# First two lines in logfile:
echo "#####################################"   &>> $LOGFILE
date &>> $LOGFILE
	echo "Calling script: \"$0\" Parameter: \"$1\" \"$2\" \"$3\" User: \"$(whoami)\"" &>> $LOGFILE


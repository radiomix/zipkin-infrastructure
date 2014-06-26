#!/bin/bash

#
# Configuration
#
# How we call the containers
IMG_PREFIX="junk/zipkin-"  #MKL

#Container name prefix
NAME_PREFIX="zipkin-"

# registry and port, we push to 
# my-registry.example.com:5000/  !! TRAILING FORWARDSLASH !! 
REGISTRY_URL=localhost:5000/  #MKL
 
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


######################################
# LOGGING
#Log date
LOGDATE=$(date '+%F-%H-%M-%S')
#Log directory
LOGDIR=../log/
# Logfile name
LOGFILE=$LOGDIR$LOGDATE"-docker.log"
# First two lines in logfile:
date >> $LOGFILE
	echo "Calling script: \"$0\" Parameter: \"$1\" \"$2\" \"$3\" User: \"$(whoami)\"" >> $LOGFILE

#Author
AUTHOR="Elemica Script"

######################################
#Container versions to revert between latest and minus_one
VERSION_LATEST="latest"
VERSION_PREVIOUS="minus_one"

#!/bin/bash

#
# Build all neccessary Docker container to run a zipkin tracing/logging app:
#

# Logfile name
LOGF_NAME="$(pwd)/$(date '+%F-%M-%S-')"

# How we call the containers
PREFIX="elemica/zipkin-"

# What containers to build
IMAGES=("base" "cassandra" "collector" "query" "web" "scribe")
IMAGES=("base")

#########
# For each container: change into the directory and build it; come back
for image in ${IMAGES[@]}; do
  pushd "../$image"
  
# Logging
  CWD=$(pwd)
  LOGFILE="$LOGF_NAME$image-Docker-build.log"
  touch $LOGFILE
  date >> $LOGFILE
  echo "Starting to build container $PREFIX$image " >> $LOGFILE

# one line of work!  
  sudo docker build --rm -t "$PREFIX$image" . >>$LOGFILE 
  
# Logging
  echo "Finished to build container $PREFIX$image " >> $LOGFILE
  date >> $LOGFILE
  popd
done




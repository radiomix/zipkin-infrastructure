#!/bin/bash

#
# Build all neccessary Docker container to run a zipkin tracing/logging app:
#


# Logfile name
LOGFILE="$(pwd)/$(date '+%F-%M-%S-')Docker-build.log"

date  >> $LOGFILE


# How we call the containers
PREFIX="elemica/zipkin-"

# registry and port, we push to 
# my-registry.example.com:5000/  !! TRAILING FORWARDSLASH !! 
REGISTRY_URL=registry.im7.de:5000/  

# What containers to build
IMAGES=("base" "cassandra" "collector" "query" "web" "fb-scribe")




#########
# For each container: change into the directory and build it; come back
for image in ${IMAGES[@]}; do
  pushd "../$image"
  
# Logging
  CWD=$(pwd)
  echo "Starting to build container $PREFIX$image logging to: " $LOGFILE

# one line of work!  
  sudo docker build --rm -t $PREFIX$image . # >> $LOGFILE 
## tag the image and push it into a repositoray
  sudo docker tag  $PREFIX$image  $REGISTRY_URL$PREFIX$image >> $LOGFILE

##FIXME what if the repo is not available??
  sudo docker push $REGISTRY_URL$PREFIX$image  >> $LOGFILE
##TODO check for the image ID and export it as a tar file

  echo "Finished to build container $PREFIX$image " >> $LOGFILE
  popd
done


sudo docker images >> $LOGFILE
sudo docker images 

exit

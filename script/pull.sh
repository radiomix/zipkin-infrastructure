#!/bin/bash

#
# Pull all neccessary Docker container to run a zipkin tracing/logging app
# off a regeistry server:
#

source ./utils.sh

CONTAINER_VERSION=$VERSION_LATEST

# test for input parameter
case "$1" in
# ----------------------------------------------------------- #
 -l|--latest)
        CONTAINER_VERSION=$VERSION_LATEST
        ;;
# ----------------------------------------------------------- #
 -h|--help|*)
  echo "
 usage: 
stop.sh --latest       stop all containers tagged as latest
stop.sh -h|--help      this message
      "
  exit
        ;;
esac



#########
# For each container: change into the directory and build it; come back
for image in ${SERVICES[@]}; do
  pushd "../$image"
  #Retagging 'latest' to 'minus_one' is ONLY done by the registry!!"
  #docker tag $IMG_PREFIX$image:$VERSION_LATEST $IMG_PREFIX$image:VERSION_MINUS_ONE
  
## pull the latest image off the repositoray and tag it
  echo "Starting to pull container $REGISTRY_URL$PREFIX$image Logging to  >> $LOGFILE"
  echo "Starting to pull container $REGISTRY_URL$PREFIX$image " >> $LOGFILE
  docker pull $REGISTRY_URL$PREFIX$image
  docker tag $REGISTRY_URL$PREFIX$image $IMG_PREFIX$image:$VERSION_LATEST
##TODO check for the image ID and export it as a tar file

  
# Logging
  echo "Finished to build container $PREFIX$image " >> $LOGFILE
  date >> $LOGFILE
  popd
done

#docker images 

exit

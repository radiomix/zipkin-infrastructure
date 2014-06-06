#!/bin/bash

#
# Delete all neccessary Docker container to run a zipkin tracing/logging app
# from a regeistry server:
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
delete.sh --latest       delete all containers tagged as latest
delete.sh -h|--help      this message
      "
  exit
        ;;
esac



#########
# For each container: change into the directory and build it; come back
for image in ${SERVICES[@]}; do
  pushd "../$image"
  #Retagging 'latest' to 'minus_one' is ONLY done by the registry!!"
  #We just retag 'latest' to $LOGDATE in order to retrieve it later "
  #docker tag $IMG_PREFIX$image:$VERSION_LATEST $IMG_PREFIX$image:$LOGDATE
  
## pull the latest image off the repositoray and tag it
  echo "Starting to delete container $REGISTRY_URL$PREFIX$image Logging to  >> $LOGFILE"
  echo "Starting to delete container $REGISTRY_URL$PREFIX$image " >> $LOGFILE
#
# We push the container, to get a valid URL to delete this container
#
  DEL_CONTAINER=$(docker push $REGISTRY_URL$PREFIX$image)
 echo "Container URL $DEL_CONTAINER"

##TODO check for the image ID and export it as a tar file

  
# Logging
  echo "Finished to build container $PREFIX$image " >> $LOGFILE
  date >> $LOGFILE
  popd
done

#docker images 

exit

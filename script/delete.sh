#!/bin/bash

#
# Delete Docker container to run a zipkin tracing/logging app
# from a regeistry server:
# We expect the first parameter to be a valid zipkin service as
# defined in file config.sh in the array ${SERVICES[@]}
#

source ./utils.sh

CONTAINER_VERSION=$VERSION_LATEST

#is first parameter a valid zipkin service?
image=$1
if isZipkinService $image ; 
then echo "** Preparing Zipkin service $image"; 
else 
    showUsage $0 $image
    exit 100
fi

#########
  
## pull the latest image off the repositoray and tag it
echo "** Starting to delete container $REGISTRY_URL$IMG_PREFIX$image Logging to  >> $LOGFILE"
echo "** Starting to delete container $REGISTRY_URL$IMG_PREFIX$image " >> $LOGFILE

# We push the container, to get a valid URL to delete this container
DEL_CONTAINER=$(docker push $REGISTRY_URL$PREFIX$image)
echo "** Container URL $DEL_CONTAINER for container  $REGISTRY_URL$IMG_PREFIX$image"

#we untag and delete the container/image locally
docker rmi $REGISTRY_URL$IMG_PREFIX$image &>/dev/null
docker rmi $IMG_PREFIX$image &>/dev/null

# Logging
echo "** Finished to delete container $IMG_PREFIX$image " >> $LOGFILE
date >> $LOGFILE

echo "** Finished to delete container $IMG_PREFIX$image " 
exit

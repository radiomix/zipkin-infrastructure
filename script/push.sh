#!/bin/bash

#
# Build all neccessary Docker container to run a zipkin tracing/logging app:
#

source ./utils.sh

#is first parameter a valid zipkin service?
image=$1
if isZipkinService $image ;
then echo "** Preparing Zipkin service $image";
else
    showUsage $0 $image
    exit 100
fi



#########
# For each container: change into the directory and build it; come back
pushd "../$image" &>/dev/null 
CWD=$(pwd) &>/dev/null
echo "Starting to push container $IMG_PREFIX$image to registry $REGISTRY_URL$IMG_PREFIX$image:$VERSION_LATEST"
echo "  logging to $LOGFILE"
##TODO what if the repo is not available??
#PUSH=$(docker push $REGISTRY_URL$IMG_PREFIX$image:$VERSION_LATEST)  &>> $LOGFILE
docker push $REGISTRY_URL$IMG_PREFIX$image:$VERSION_LATEST  &>> $LOGFILE
##TODO check for the image ID and export it as a tar file

echo "Finished to push container $IMG_PREFIX$image " &>> $LOGFILE
docker images | grep $REGISTRY_URL &>> $LOGFILE
date &>> $LOGFILE

echo "Finished to push container $IMG_PREFIX$image " 
docker images | grep $REGISTRY_URL

exit

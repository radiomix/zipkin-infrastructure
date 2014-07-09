#!/bin/bash

#
# Build all neccessary Docker container to run a zipkin tracing/logging app:
#

source ./utils.sh

if isZipkinService $image ;
then echo "** Preparing Zipkin service $image";
else
    showUsage $0 $image
    exit 100
fi


#########
# For each container: change into the directory and build it; come back
echo "** Preparing to push container to registry $REGISTRY_URL"
REGISTRY_PING=$(curl http://$REGISTRY_URL/_ping) &>> $LOGFILE
if [ ! "$REGISTRY_PING" == "true" ] 
then 
  echo "** ERROR: $REGISTRY_URL:$REGISTRY_PING not reachable "  &>> $LOGFILE
  echo "** ERROR: $REGISTRY_URL:$REGISTRY_PING not reachable " 
  exit 100
fi
echo "**  Registry $REGISTRY_URL:$REGISTRY_PING " 
echo "**  logging to $LOGFILE"
pushd "../$image" &>/dev/null 
CWD=$(pwd) &>/dev/null
echo "** Pushing container $IMG_PREFIX$image to registry $REGISTRY_URL$IMG_PREFIX$image:$VERSION_LATEST" &>> $LOGFILE
echo "** Pushing container $IMG_PREFIX$image to registry $REGISTRY_URL$IMG_PREFIX$image:$VERSION_LATEST"
PUSH=$(docker push $REGISTRY_URL$IMG_PREFIX$image:$VERSION_LATEST)  &>> $LOGFILE
##TODO check for the image ID and export it as a tar file
echo "** $PUSH "
echo "** Finished to push container $IMG_PREFIX$image " &>> $LOGFILE
echo "** Finished to push container $IMG_PREFIX$image "
docker images | grep $REGISTRY_URL &>> $LOGFILE
date &>> $LOGFILE

echo "** Finished to push container $IMG_PREFIX$image " 
docker images | grep $REGISTRY_URL

exit

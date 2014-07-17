#!/bin/bash

#
# Pull all neccessary Docker container to run a zipkin tracing/logging app
# off a regeistry server:
#

# check, how we are called to source our utilities
DIRNAME=$(dirname $0)
## this file contains configuration and functions
source ${DIRNAME}/utils.sh

CONTAINER_VERSION=$VERSION_LATEST

if isZipkinService $image ; 
then echo "** Preparing Zipkin service $image"; 
else 
    showUsage $0 $image
    exit 100
fi


#########
#Retagging 'latest' to 'minus_one' is ONLY done by the registry!!"
#We might retag 'latest' to $LOGDATE in order to retrieve it later "
#docker tag $IMG_PREFIX$image:$VERSION_LATEST $IMG_PREFIX$image:$LOGDATE
echo "** Preparing to pull from $REGISTRY_URL"
REGISTRY_PING=$(curl http://$REGISTRY_URL/_ping) &>> $LOGFILE
if [ ! "$REGISTRY_PING" == "true" ]
then
  echo "** ERROR: $REGISTRY_URL:$REGISTRY_PING not reachable "  &>> $LOGFILE
  echo "** ERROR: $REGISTRY_URL:$REGISTRY_PING not reachable " 
  exit 100
fi
  
## pull the latest image off the repositoray and tag it
echo "** Starting to pull container $REGISTRY_URL$IMG_PREFIX$image Logging to  $LOGFILE"
echo "** Starting to pull container $REGISTRY_URL$IMG_PREFIX$image " &>> $LOGFILE
docker pull $REGISTRY_URL$IMG_PREFIX$image:$VERSION_LATEST &>> $LOGFILE
docker tag $REGISTRY_URL$IMG_PREFIX$image:$VERSION_LATEST $IMG_PREFIX$image:$VERSION_LATEST &>> $LOGFILE
##TODO check for the image ID and export it as a tar file

  
# Logging
docker images | grep $IMG_PREFIX$image &>> $LOGFILE
docker images | grep $IMG_PREFIX$image
echo "** Finished to pull container $IMG_PREFIX$image " &>> $LOGFILE
date &>> $LOGFILE

echo "** Finished to pull container $IMG_PREFIX$image "

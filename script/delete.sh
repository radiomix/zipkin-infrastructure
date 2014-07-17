#!/bin/bash

#
# Delete Docker container to run a zipkin tracing/logging app
# from a regeistry server:
# We expect the first parameter to be a valid zipkin service as
# defined in file config.sh in the array ${SERVICES[@]}
#

# check, how we are called to source our utilities
DIRNAME=$(dirname $0)
## this file contains configuration and functions
source ${DIRNAME}/utils.sh


if isZipkinService $image ; 
then echo "** Preparing Zipkin service $image"; 
else 
    showUsage $0 $image
    exit 100
fi

#########
echo "** Starting to delete container $REGISTRY_URL$IMG_PREFIX$image "
echo "** Starting to delete container $REGISTRY_URL$IMG_PREFIX$image " &>> $LOGFILE

# We push the container, to get a valid URL to delete this container
DEL_CONTAINER=$(docker push $REGISTRY_URL$PREFIX$image)
echo "** Container URL $DEL_CONTAINER for container  $REGISTRY_URL$IMG_PREFIX$image"

#we untag and delete the container/image locally
docker rmi $REGISTRY_URL$IMG_PREFIX$image &>> $LOGFILE
docker rmi $IMG_PREFIX$image  &>> $LOGFILE

# Logging
date	&>> $LOGFILE

echo "** Finished to delete container $IMG_PREFIX$image " 

#!/bin/bash

#
# Build all neccessary Docker container to run a zipkin tracing/logging app:
#

source ./utils.sh


# Logfile name
LOGFILE="$(pwd)/$(date '+%F-%M-%S-')Docker-build.log"

date  >> $LOGFILE





#########
# For each container: change into the directory and build it; come back
for image in ${SERVICES[@]}; do
  pushd "../$image"
  
# Logging
  CWD=$(pwd)
  echo "Starting to build container $PREFIX$image logging to: " $LOGFILE

  BUILD=$(docker build --rm -t $PREFIX$image .)  >> $LOGFILE  	#get build output into variable
  CID=$(echo $BUILD | sed  's/^.*built.//') &>/dev/null 	#extract container id

## tag the image and push it into a repositoray
  TAG=$(docker tag  $PREFIX$image  $REGISTRY_URL$PREFIX$image:$VERSION_LATEST) >> $LOGFILE
##FIXME what if the repo is not available??
  PUSH=$(docker push $REGISTRY_URL$PREFIX$image:$VERSION_LATEST)  >> $LOGFILE
##TODO check for the image ID and export it as a tar file
exit
  echo "Finished to build container $PREFIX$image " >> $LOGFILE
  popd
done


docker images >> $LOGFILE
docker images 

exit

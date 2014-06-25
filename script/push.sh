#!/bin/bash

#
# Build all neccessary Docker container to run a zipkin tracing/logging app:
#

source ./utils.sh


 
# test for input parameter
case "$1" in
# ----------------------------------------------------------- #
 -b|--base)
        SERVICES=(base)
        ;;
# ----------------------------------------------------------- #
 -z|--zipkin)
        ;;
# ----------------------------------------------------------- #
 -h|--help|*)
  echo "
 usage: 
push.sh -b|--base      push only base container
push.sh -z| --zipkin   push all zipkin containers 
push.sh -h|--help      this message
      "
  exit
        ;;
esac

for i in ${SERVICES[@]}; do
  echo "** Prepare to build  container type $i "
done	

#########
# For each container: change into the directory and build it; come back
for image in ${SERVICES[@]}; do
  pushd "../$image"
  CWD=$(pwd) >>/dev/null
  echo "Starting to push container $IMG_PREFIX$image to registry $REGISTRY_URL$IMG_PREFIX$image:$VERSION_LATEST"
  echo "  logging to $CWD/$LOGFILE"
##FIXME what if the repo is not available??
  #PUSH=$(docker push $REGISTRY_URL$IMG_PREFIX$image:$VERSION_LATEST)  >> $LOGFILE
  docker push $REGISTRY_URL$IMG_PREFIX$image:$VERSION_LATEST  #>> $LOGFILE
##TODO check for the image ID and export it as a tar file
  echo "Finished to push container $IMG_PREFIX$image " 
  popd
done


docker images | grep $REGISTRY_URL

exit

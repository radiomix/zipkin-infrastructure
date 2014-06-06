#!/bin/bash

#
# Build all neccessary Docker container to run a zipkin tracing/logging app:
#

source ./utils.sh


 
# test for input parameter
case "$1" in
# ----------------------------------------------------------- #
 -b|--base)
        SERVICES="base"
        ;;
# ----------------------------------------------------------- #
 -z|--zipkin)
        ;;
# ----------------------------------------------------------- #
 -h|--help|*)
  echo "
 usage: 
build.sh -b|--base 	build only base container
build.sh -z| --zipkin   build all zipkin containers 
build.sh -h|--help      this message
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
  echo "Starting to build container $IMG_PREFIX$image "
  echo "  in directory $CWD  "
  echo "  logging to $CWD/$LOGFILE"
  docker build --rm -t $IMG_PREFIX$image . #>> $LOGFILE  	#get build output into logfile
  #BUILD=$(cat $LOGFILE) 
  #CID=$(echo $BUILD | sed  's/^.*built.//') &>/dev/null 	#extract container id
## tag the image and push it into a repositoray
  #TAG=$(docker tag  $IMG_PREFIX$image  $REGISTRY_URL$IMG_PREFIX$image:$VERSION_LATEST) >> $LOGFILE
  docker tag  $IMG_PREFIX$image  $REGISTRY_URL$IMG_PREFIX$image:$VERSION_LATEST #>> $LOGFILE
##FIXME what if the repo is not available??
  #PUSH=$(docker push $REGISTRY_URL$IMG_PREFIX$image:$VERSION_LATEST)  >> $LOGFILE
  docker push $REGISTRY_URL$IMG_PREFIX$image:$VERSION_LATEST  #>> $LOGFILE
##TODO check for the image ID and export it as a tar file
  echo "Finished to build container $IMG_PREFIX$image " 
  popd
done


docker images 

exit

#!/bin/bash

#
# Build all neccessary Docker container to run a zipkin tracing/logging app:
#

source ./utils.sh


# Logfile name
LOGFILE="$(pwd)/$(date '+%F-%M-%S-')Docker-build.log"

date  >> $LOGFILE


 
# test for input parameter
case "$1" in
# ----------------------------------------------------------- #
 -b|--base)
        SERVICES="base"
	echo "** Building base container only "
        ;;
# ----------------------------------------------------------- #
 -z|--zipkin)
       	for image in ${SERVICES[@]}; do
	   echo "** Prepare to build  container type $i "
	done	
        
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

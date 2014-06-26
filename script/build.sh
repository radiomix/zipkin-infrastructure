#!/bin/bash

#
# Build Docker container to run a zipkin tracing/logging app:
#
# We expect the first parameter to be a valid zipkin service as
# defined in file config.sh in the array ${SERVICES[@]}
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
pushd "../$image" &>/dev/null
CWD=$(pwd) >>/dev/null
echo "** Starting to build container $IMG_PREFIX$image "
echo "**  in directory $CWD  "
echo "**  logging to $CWD/$LOGFILE"
docker build --rm -t $IMG_PREFIX$image . #>> $LOGFILE  	#get build output into logfile

#logging
docker images | grep $IMG_PREFIX$image  >> $LOGFILE
echo "** Finished to build container $IMG_PREFIX$image " >> $LOGFILE
date >> $LOGFILE

echo "** Finished to build container $IMG_PREFIX$image " 
exit

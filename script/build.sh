#!/bin/bash

#
# Build Docker container to run a zipkin tracing/logging app:
#
# We expect the first parameter to be a valid zipkin service as
# defined in file config.sh in the array ${SERVICES[@]}
#

# check, how we are called 
DIRNAME=${DIRNAME:="script"}
if [ ! -f $DIRNAME/utils.sh ]
then 
 echo "** ERROR don't call this script within this directory "
 exit 100
fi
## this file contains configuration and functions
source ${DIRNAME}/utils.sh 


if isZipkinService $image ; 
then echo "** Preparing Zipkin service $image"; 
else 
    showUsage $0 $image
    exit 100
fi
#########
pushd "$image" &>> /dev/null 
echo "** Starting to build container $IMG_PREFIX$image in direcotry `pwd` "
docker build --rm -t $IMG_PREFIX$image . &>> $LOGFILE  	#get build output into logfile

#logging
docker images | grep $IMG_PREFIX$image  &>> $LOGFILE
echo "** Finished to build container $IMG_PREFIX$image " &>> $LOGFILE
date >> $LOGFILE

echo "** Finished to build container $IMG_PREFIX$image " 

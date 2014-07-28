#!/bin/bash


# check, how we are called  
DIRNAME=${DIRNAME:="script"} 
if [ ! -f $DIRNAME/utils.sh ] 
then 
 echo "** ERROR don't call this script within this directory " 
 exit 100 
fi 
## this file contains configuration and functions 
source ${DIRNAME}/utils.sh 

#is first parameter a valid zipkin service?
image=$1
key=$2
if isZipkinService $image ;
then /bin/true 
else
    showUsage $0 $image
    exit 100
fi

if isDockerKey $key;
then /bin/true
else 
   echo "** Second Argument must be a valid docker key like:"
   echo "** ${DOCKER_INSPECT[@]}"
   exit 100
fi
echo "**  Inspecting container $NAME_PREFIX$image " &>> $LOGFILE
echo "**  Inspecting container $NAME_PREFIX$image "
#inspect the container/image and ask for $key
docker inspect -f="{{json .$key}}" "${NAME_PREFIX}$image" &>> $LOGFILE 
docker inspect -f="{{json .$key}}" "${NAME_PREFIX}$image"  
date &>> $LOGFILE

echo "** Finished to inspect container $IMG_PREFIX$image "

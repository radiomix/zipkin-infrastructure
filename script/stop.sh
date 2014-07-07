#!/bin/bash


## this file contains configuration and functions
source ./utils.sh

if isZipkinService $image ;
then echo "** Preparing Zipkin service $image";
else
    showUsage $0 $image
    exit 100
fi

echo "**  Stoping container $NAME_PREFIX$image " &>> $LOGFILE
echo "**  Stoping container $NAME_PREFIX$image "
##TODO check if container exists and then maybe commit it as an image???
docker stop "${NAME_PREFIX}$image" &>> $LOGFILE	#redirect stdout&stderror 
date &>> $LOGFILE
exit 

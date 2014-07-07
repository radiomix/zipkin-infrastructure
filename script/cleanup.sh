#!/bin/bash
#
# kill running container and remove it
#
source ./utils.sh


if isZipkinService $image ;
then echo "** Preparing Zipkin service $image";
else
    showUsage $0 $image
    exit 100
fi


echo "** Killing container $image and remove it" &>> $LOGFILE
echo "** Killing container $image and remove it"
docker kill ${NAME_PREFIX}$image  &>> $LOGFILE
docker rm ${NAME_PREFIX}$image  &>> $LOGFILE


#next two lines would kill/remove EVERY container   
#docker ps -aq | xargs docker kill &>> $LOGFILE
#docker ps -aq | xargs docker rm  &>> $LOGFILE

#show what is left:
docker ps -a | grep $image

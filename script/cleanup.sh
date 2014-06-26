#!/bin/bash
#
# kill running container and remove it
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


echo "** Killing container $image and remove it" >> $LOGFILE
echo "** Killing container $image and remove it"
docker kill ${NAME_PREFIX}$image  &>/dev/null
docker rm ${NAME_PREFIX}$image  &>/dev/null


#next two lines would kill/remove EVERY container   
#docker ps -aq | xargs docker kill &>/dev/null
#docker ps -aq | xargs docker rm  &>/dev/null

#show what is left:
docker ps -a | grep $image

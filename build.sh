#!/bin/bash

#
# We build the zipkin infrastructure: cassandra, collector, query and web as docker container
#
DIRNAME="script"
## this file contains configuration and functions
source $DIRNAME/utils.sh


 case "$1" in
 # ----------------------------------------------------------- #
   --base| -b )
     echo "** Building base container"
     ${DIRNAME}/build.sh base
 ;;
 # ----------------------------------------------------------- #
   --fb-scribe| -f )
     echo "** Building fb-scribe container"
     ${DIRNAME}/build.sh fb-scribe 
 ;;
 # ----------------------------------------------------------- #
   --zipkin| -z )
     echo "** Building zipkin containers"
   for image in ${ZIPKIN_SERVICES[@]}; do
     ${DIRNAME}/build.sh $image
   done
 ;;
 # ----------------------------------------------------------- #
   --registry| -r )
     echo "** Pullin zipkin containers from registry REGISTRY_URL"
   for image in ${ZIPKIN_SERVICES[@]}; do
     ${DIRNAME}/pull.sh $image
   done
   docker images -a | grep $NAME_PREFIX &>> $LOGFILE
   docker images -a | grep $NAME_PREFIX 
  ;;
 # ----------------------------------------------------------- #
   --help | -h | * )
   echo "** USAGE: 
   build.sh --base| -b
               to only build ${NAME_PREFIX}base container
   build.sh --fb-scribe| -f
               to only build ${NAME_PREFIX}fb-scribe container
   build.sh --zipkin| -z
               to freshly build all zipkin ${NAME_PREFIX}containers
   build.sh --registry | -r
               to pull new ${NAME_PREFIX}containers from registry
   build.sh --help| -h
               to show this message"
 ;;

 esac

 # ----------------------------------------------------------- #
echo "** Finished $0 "

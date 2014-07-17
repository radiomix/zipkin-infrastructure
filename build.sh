#!/bin/bash

#
# We build the zipkin infrastructure: cassandra, collector, query and web as docker container
#

# check, how we are called to source our utilities
DIRNAME=script
## this file contains configuration and functions
source ${DIRNAME}/utils.sh


 case "$1" in
 # ----------------------------------------------------------- #
   --fresh | -f )
   for image in ${ZIPKIN_SERVICES[@]}; do
     ${DIRNAME}/build.sh $image
   done
 ;;
 # ----------------------------------------------------------- #
   --registry| -r )
   for image in ${ZIPKIN_SERVICES[@]}; do
     ${DIRNAME}/pull.sh $image
   done
   docker images -a | grep $NAME_PREFIX &>> $LOGFILE
   docker images -a | grep $NAME_PREFIX 
  ;;
 # ----------------------------------------------------------- #
   --help | -h | * )
   echo "** USAGE: 
   build.sh --fresh | -f
               to freshly build ${NAME_PREFIX}containers
   build.sh --registry | -r
               to pull new ${NAME_PREFIX}containers from registry
   build.sh --help| -h
               to show this message"
 ;;

 esac

 # ----------------------------------------------------------- #
echo "** Finished $0 "

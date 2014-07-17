#!/bin/bash

#
# We deploy the zipkin infrastructure: cassandra, collector, query and web as docker container
#

# check, how we are called to source our utilities
DIRNAME=script
## this file contains configuration and functions
source ${DIRNAME}/utils.sh


 case "$1" in
 # ----------------------------------------------------------- #
   --cleanup| -c )
   for image in ${ZIPKIN_SERVICES[@]}; do
    ${DIRNAME}/cleanup.sh $image
   done
 ;;
 # ----------------------------------------------------------- #
   --run| -r )
   for image in ${ZIPKIN_SERVICES[@]}; do
    ${DIRNAME}/start.sh $image
   done
  ;;
 # ----------------------------------------------------------- #
   --help | -h | * )
   echo "** USAGE: 
   deploy.sh --cleanup | -c
               to cleanup old ${NAME_PREFIX}containers
   deploy.sh --run | -r
               to run new ${NAME_PREFIX}containers
   deploy.sh --help | -h
               to show this message"
   exit
 ;;

 esac

 # ----------------------------------------------------------- #
echo "** Finished $0 "

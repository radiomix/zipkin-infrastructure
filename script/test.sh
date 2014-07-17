#!/bin/bash

# testing arrayContainsElement 
# check, how we are called to source our utilities
DIRNAME=$(dirname $0)
## this file contains configuration and functions
source ${DIRNAME}/utils.sh

echo "** TESTING ${SERVICES[@]} "
echo "** Logging into \"$LOGFILE\"" 
echo "** --------------------- STARTING TEST ----------"  &>> $LOGFILE
date &>> $LOGFILE


##TODO check output of scripts
for s in ${SERVICES[@]} ;
do 
 ./build.sh $s
 ./push.sh $s
 ./pull.sh $s 
 ./start.sh $s 
 ./stop.sh $s 
 ./cleanup.sh $s
done

date &>> $LOGFILE
echo "** --------------------- FINISHED TEST ----------"  &>> $LOGFILE
echo "** TESTING DONE "
echo "** Please inspect logfile \"$LOGFILE\"" 


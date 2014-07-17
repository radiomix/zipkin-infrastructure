#!/bin/bash

# testing arrayContainsElement 
# check, how we are called to source our utilities
DIRNAME=$(dirname $0)
## this file contains configuration and functions
source ${DIRNAME}/utils.sh

echo "** TESTING ${SERVICES[@]} "
echo "** --------------------- STARTING TEST ----------"  &>> $LOGFILE
date &>> $LOGFILE


##TODO check output of scripts
for s in ${SERVICES[@]} ;
do 
 ${DIRNAME}/build.sh $s
 ${DIRNAME}/push.sh $s
 ${DIRNAME}/pull.sh $s 
 ${DIRNAME}/start.sh $s 
 ${DIRNAME}/stop.sh $s 
 ${DIRNAME}/cleanup.sh $s
done

date &>> $LOGFILE
echo "** --------------------- FINISHED TEST ----------"  &>> $LOGFILE
echo "** TESTING DONE "
echo "** Please inspect logfile \"$LOGFILE\"" 


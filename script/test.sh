#!/bin/bash

# testing arrayContainsElement 
# check, how we are called  
DIRNAME=${DIRNAME:="script"} 
if [ ! -f $DIRNAME/utils.sh ] 
then 
 echo "** ERROR don't call this script within this directory " 
 exit 100 
fi 
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
echo "** Please inspect logfile \"$LOGFILE\"" 
echo "** TESTING DONE "

#!/bin/bash

# testing arrayContainsElement 

source ./utils.sh

echo " TESTING ${SERVICES[@]} "
echo "--------------------- STARTING TEST ----------"  &>> $LOGFILE
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
echo "--------------------- FINISHED TEST ----------"  &>> $LOGFILE
echo "DONE TESTING "
echo "Please inspect logfile \"$LOGFILE\"" 


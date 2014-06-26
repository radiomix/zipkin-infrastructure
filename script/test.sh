#!/bin/bash

# testing arrayContainsElement 

source ./utils.sh

echo " TESTING ${SERVICES[@]} "


for s in ${SERVICES[@]} ;
do 
 ./build.sh $s
 ./push.sh $s
 ./pull.sh $s 
 ./start.sh $s 
 ./stop.sh $s 
 ./cleanup.sh $s
done


echo "DONE TESTING "
echo "Please inspect " 


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
   # first we inspect which containers are running
   # ----------------------------------------------------------- #
	 echo "** Checking if container ${NAME_PREFIX}$image is present/running " &>> $LOGFILE
	 echo "** Checking if container ${NAME_PREFIX}$image is present/running "
	 docker ps -a  |  grep "${NAME_PREFIX}$image"  &>> $LOGFILE
	 if [ $? == "0" ]
	 then
	     echo "** Container " ${RUNNING[@]}
	     echo  "** Please stop and remove container ${NAME_PREFIX}$image by issuing commands "
	     echo  "**:> ${DIRNAME}/cleanup.sh $image"
	     echo  "**  EXIT 100"
	     exit 100
	 fi

   # than we inspect which containers are named allready
   # ----------------------------------------------------------- #
	 docker ps  -a | grep Exited | grep "${NAME_PREFIX}$image"
	 if [ $? == "0" ]
	 then
	     echo "** Please remove container ${NAME_PREFIX}$image by issuing command"
	     echo "**:> ${DIRNAME}/cleanup.sh $image"
	     echo "**  EXIT"
	     exit 100
	 fi

   # Start container $image
   # We expect it to be down!
   # ----------------------------------------------------------- #
	 echo "** Starting Container" $image &>> $LOGFILE
	 echo "** Starting Container" $image

	 case "$image" in
   # ----------------------------------------------------------- #
	     cassandra)
		 echo "** Starting zipkin-cassandra"
		 PS_CASSANDRA=$(docker run -d --name="${NAME_PREFIX}cassandra" "${IMG_PREFIX}cassandra") &>> $LOGFILE
		 ;;
	     collector) 
		 echo "** Starting zipkin-collector"
		 PS_COLLECTOR=$(docker run -d --link="${NAME_PREFIX}cassandra:db" -p 9410:$COLLECTOR_PORT -p 9900:$COLLECTOR_MGT_PORT --name="${NAME_PREFIX}collector" "${IMG_PREFIX}collector") &>> $LOGFILE
		 ;;
	     query)
		 echo "** Starting zipkin-query"
		 PS_QUERY=$(docker run -d --link="${NAME_PREFIX}cassandra:db" -p 9411:$QUERY_PORT --name="${NAME_PREFIX}query" "${IMG_PREFIX}query") &>> $LOGFILE
		 ;;
	     web)
		 echo "** Starting zipkin-web"
		 PS_WEB=$(docker run -d --link="${NAME_PREFIX}query:query" -p 8080:$WEB_PORT -e "ROOTURL=${ROOT_URL}" --name="${NAME_PREFIX}web" "${IMG_PREFIX}web") &>> $LOGFILE
		 ;;
	  esac

	  echo "** Finished starting Container $image "
	  UP=$(docker ps -a | grep Up | grep " ${NAME_PREFIX}$image")
	  if  [ -n "$UP"  ]
	  then
	      echo "** Container ${NAME_PREFIX}$image Up" &>> $LOGFILE
	      echo "** Container ${NAME_PREFIX}$image Up"
	  else 
	      echo "** ERROR: Container  ${NAME_PREFIX}$image NOT RUNNING!! " &>> $LOGFILE
	      echo "** ERROR: Container  ${NAME_PREFIX}$image NOT RUNNING!! "
	  fi
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
 docker ps  -a | grep $NAME_PREFIX &>> $LOGFILE
 docker ps  -a | grep $NAME_PREFIX 
echo "** Finished $0 "
 date &>> $LOGFILE

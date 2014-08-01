#!/bin/bash


# check, how we are called  
DIRNAME=${DIRNAME:="script"} 
if [ ! -f $DIRNAME/utils.sh ] 
then 
 echo "** ERROR don't call this script within this directory " 
 exit 100 
fi 
## this file contains configuration and functions 
source ${DIRNAME}/utils.sh 


if isZipkinService $image ; 
then echo "** Preparing Zipkin service $image"; 
else 
    showUsage $0 $image
    exit 100
fi


# first we inspect which containers are running
# ----------------------------------------------------------- #
echo "** Checking if container ${IMG_PREFIX}$image is present/running "
RUNNING=$(docker ps -a  |  grep "${IMG_PREFIX}$image" )
if [ $? == "0" ]
 then
   echo "** Existing container " ${RUNNING[@]} &>> $LOGFILE
   echo "** Existing container " ${RUNNING[@]}
   echo  "** Please stop and remove container ${IMG_PREFIX}$image by issuing commands "
   echo  "**:> ${DIRNAME}/cleanup.sh $image"
   echo  "**  EXIT 100"
   exit 100
fi

# than we inspect which containers are named allready
# ----------------------------------------------------------- #
docker ps  -a | grep Exited | grep "${IMG_PREFIX}$image"
 if [ $? == "0" ]
 then
   echo "** Please remove container ${IMG_PREFIX}$image by issuing command"
   echo "**:> ${DIRNAME}/cleanup.sh $image"
   echo "**  EXIT"
   exit 100
fi



##TODO Deploy conainer only completely as zipkin infrastructure as in [docker-zipkin](https://github.com/lispmeister/docker-zipkin/blob/master/deploy/deploy.sh)

# ----------------------------------------------------------- #
# Start container $image
# We expect it to be down!
# ----------------------------------------------------------- #
echo "** Starting Container" $image &>> $LOGFILE
echo "** Starting Container" $image

# only start selected container
case "$image" in
# ----------------------------------------------------------- #
 fb-scribe)
        echo "** Starting fb-scribe"
        #PS=$(docker run -d --link="${NAME_PREFIX}query:query" -p 8080:$WEB_PORT -e "ROOTURL=${ROOT_URL}" --name="${NAME_PREFIX}fb-scribe" "${IMG_PREFIX}fb-scribe" /bin/bash) &>> $LOGFILE
        PS=$(docker run -d -p 1463:$FB_SCRIBE_PORT  --name="${NAME_PREFIX}fb-scribe" "${IMG_PREFIX}fb-scribe" /bin/bash) &>> $LOGFILE
	;;
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
# ----------------------------------------------------------- #

UP=$(docker ps -a | grep Up | grep " ${NAME_PREFIX}$image")
if  [ -n "$UP"  ]
then
    echo "** Container ${NAME_PREFIX}$image Up" &>> $LOGFILE
    echo "** Container ${NAME_PREFIX}$image Up"
else 
   echo "** ERROR: Container  ${NAME_PREFIX}$image NOT RUNNING!! " &>> $LOGFILE
   echo "** ERROR: Container  ${NAME_PREFIX}$image NOT RUNNING!! "
fi
docker ps  -a | grep $NAME_PREFIX$image &>> $LOGFILE
docker ps  -a | grep $NAME_PREFIX$image
date &>> $LOGFILE

echo "** Finished to start container $image "

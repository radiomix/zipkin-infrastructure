#!/bin/bash


source ./utils.sh

CONTAINER_VERSION=$VERSION_LATEST

#is first parameter a valid zipkin service?
image=$1
if isZipkinService $image ; 
then echo "** Preparing Zipkin service $image"; 
else 
    showUsage $0 $image
    exit 100
fi


# first we inspect which containers are running
# ----------------------------------------------------------- #
echo " Checking if container ${NAME_PREFIX}$image is present/running "
RUNNING=$(docker ps -a  |  grep "${NAME_PREFIX}$image" )
if [ $? == "0" ]
 then
   echo "** Container " ${RUNNING[@]}
   echo  "** Please stop and remove container ${NAME_PREFIX}$image by issuing commands "
   echo  "** docker kill ${NAME_PREFIX}$image"
   echo  "** docker rm ${NAME_PREFIX}$image"
   echo  "**  EXIT 100"
   exit 100
fi

# than we inspect which containers are named allready
# ----------------------------------------------------------- #
docker ps  -a | grep Exited | grep "${NAME_PREFIX}$image"
 if [ $? == "0" ]
 then
   echo "** Please remove container ${NAME_PREFIX}$image by issuing command"
   echo "** docker rm ${NAME_PREFIX}$image"
   echo "**  EXIT"
   exit 100
fi



##TODO maybe we should split starting each container into a seperate file!!
# ----------------------------------------------------------- #
# Start container $image
# We expect it to be down!
# ----------------------------------------------------------- #
echo "** Starting Container" $image >> $LOGFILE
echo "** Starting Container" $image

# only start selected container
case "$image" in
# ----------------------------------------------------------- #
 fb-scribe)
        echo "** Starting fb-scribe"
        PS=$(docker run -d --link="${NAME_PREFIX}query:query" -p 8080:$WEB_PORT -e "ROOTURL=${ROOT_URL}" --name="${NAME_PREFIX}fb-scribe" "${IMG_PREFIX}fb-scribe" /bin/bash) #&>/dev/null
	;;
# ----------------------------------------------------------- #
 cassandra)
        echo "** Starting zipkin-cassandra"
        PS_CASSANDRA=$(docker run -d --name="${NAME_PREFIX}cassandra" "${IMG_PREFIX}cassandra") #&>/dev/null
        ;;
 collector) 
        echo "** Starting zipkin-collector"
        PS_COLLECTOR=$(docker run -d --link="${NAME_PREFIX}cassandra:db" -p 9410:$COLLECTOR_PORT -p 9900:$COLLECTOR_MGT_PORT --name="${NAME_PREFIX}collector" "${IMG_PREFIX}collector") #&>/dev/null
	;;
  query)
        echo "** Starting zipkin-query"
        PS_QUERY=$(docker run -d --link="${NAME_PREFIX}cassandra:db" -p 9411:$QUERY_PORT --name="${NAME_PREFIX}query" "${IMG_PREFIX}query") #&>/dev/null
	;;
  web)
        echo "** Starting zipkin-web"
        PS_WEB=$(docker run -d --link="${NAME_PREFIX}query:query" -p 8080:$WEB_PORT -e "ROOTURL=${ROOT_URL}" --name="${NAME_PREFIX}web" "${IMG_PREFIX}web") #&>/dev/null
	;;
esac
# ----------------------------------------------------------- #

UP=$(docker ps -a | grep Up | grep " ${NAME_PREFIX}$image")
if  [ -n "$UP"  ]
then
    echo "** Container ${NAME_PREFIX}$image Up" >> $LOGGILE
    echo "** Container ${NAME_PREFIX}$image Up"
else 
   echo "** ERROR: Container  ${NAME_PREFIX}$image NOT RUNNING!! " >> $LOGFILE
   echo "** ERROR: Container  ${NAME_PREFIX}$image NOT RUNNING!! "
fi
docker ps  -a | grep $NAME_PRFIX$image >> $LOGFILE
docker ps  -a | grep $NAME_PRFIX$image

date >> $LOGFILE
echo "** Finished starting Container $image "

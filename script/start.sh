#!/bin/bash


source ./utils.sh

CONTAINER_VERSION=$VERSION_LATEST

# test for input parameter
case "$1" in
# ----------------------------------------------------------- #
 -s|--scribe)
	SERVICES=( "${SCRIBE_SERVICES[@]}" ) #copy array
	;;
# ----------------------------------------------------------- #
 -z|--zipkin)
	SERVICES=( "${ZIPKIN_SERVICES[@]}" ) #copy array
	;;
# ----------------------------------------------------------- #
 -h|--help|*)
  echo "
 usage: 
start.sh  -s | --scribe   start scribe client container 
start.sh  -z | --zipkin   start zipkin containers  (cassandra collector query web)
start.sh -h|--help      this message
      "
  exit
	;;
esac
# ----------------------------------------------------------- #


# first we inspect which containers are running
# ----------------------------------------------------------- #
  for i in "${SERVICES[@]}"; do
    echo " Checking if container ${NAME_PREFIX}$i is present/running "
    RUNNING=$(docker ps -a  |  grep "${NAME_PREFIX}$i" )
    if [ $? == "0" ]
    then
       echo "** Container " ${RUNNING[@]}
       echo  "** Please stop and remove container ${NAME_PREFIX}$i by issuing commands "
       echo  "** docker kill ${NAME_PREFIX}$i"
       echo  "** docker rm ${NAME_PREFIX}$i"
       echo  "**  EXIT 100"
       exit 100
    fi
  done

# than we inspect which containers are named allready
# ----------------------------------------------------------- #
  for i in "${SERVICES[@]}"; do
    docker ps  -a | grep Exited | grep "${NAME_PREFIX}$i"
    if [ $? == "0" ]
    then
      echo  "** Please commit and remove container ${NAME_PREFIX}$i by issuing command"
      echo "** docker commit  ${NAME_PREFIX}$i ${IMG_PREFIX}$i:TAG_NAME"
      echo "** docker rm ${NAME_PREFIX}$i"
      echo "**  EXIT"
      exit 100
    fi
  done


# ----------------------------------------------------------- #
# Start all containers in $SERVICES
# We expect them to be down!
# ----------------------------------------------------------- #
echo " Starting Container" ${SERVICES[@]}

# only start selected container
case "$1" in
# ----------------------------------------------------------- #
 -s|--scribe)
        PS=$(docker run -d --link="${NAME_PREFIX}query:query" -p 8080:$WEB_PORT -e "ROOTURL=${ROOT_URL}" --name="${NAME_PREFIX}fb-scribe" "${IMG_PREFIX}fb-scribe" /bin/bash) #&>/dev/null
	;;
# ----------------------------------------------------------- #
 -z|--zipkin)
        echo "** Starting zipkin-cassandra"
        PS_CASSANDRA=$(docker run -d --name="${NAME_PREFIX}cassandra" "${IMG_PREFIX}cassandra") #&>/dev/null
  
        echo "** Starting zipkin-collector"
        PS_COLLECTOR=$(docker run -d --link="${NAME_PREFIX}cassandra:db" -p 9410:$COLLECTOR_PORT -p 9900:$COLLECTOR_MGT_PORT --name="${NAME_PREFIX}collector" "${IMG_PREFIX}collector") #&>/dev/null

        echo "** Starting zipkin-query"
        PS_QUERY=$(docker run -d --link="${NAME_PREFIX}cassandra:db" -p 9411:$QUERY_PORT --name="${NAME_PREFIX}query" "${IMG_PREFIX}query") #&>/dev/null

        echo "** Starting zipkin-web"
        PS_WEB=$(docker run -d --link="${NAME_PREFIX}query:query" -p 8080:$WEB_PORT -e "ROOTURL=${ROOT_URL}" --name="${NAME_PREFIX}web" "${IMG_PREFIX}web") #&>/dev/null

	;;
esac
# ----------------------------------------------------------- #

  for i in "${SERVICES[@]}"; do
    UP=$(docker ps -a | grep Up | grep " ${NAME_PREFIX}$i")
    if  [ -n "$UP"  ]
    then
      echo "** Container ${NAME_PREFIX}$i Up"
     else 
     echo "** ERROR: Container  ${NAME_PREFIX}$i NOT RUNNING!! "
  fi
  done
  docker ps  -a



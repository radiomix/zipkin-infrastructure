#!/bin/bash

#
# Pull all neccessary Docker container to run a zipkin tracing/logging app
# off a regeistry server:
#

# Logfile name
LOGF_NAME="$(pwd)/$(date '+%F-%M-%S-')"


#########
# For each container: change into the directory and build it; come back
for image in ${SERVICES[@]}; do
  pushd "../$image"
  
# Logging
  CWD=$(pwd)
  LOGFILE="$LOGF_NAME$image-Docker-build.log"
  touch $LOGFILE
  date >> $LOGFILE
  echo "Starting to pull container $REGISTRY_URL$PREFIX$image Logging to  >> $LOGFILE"
  echo "Starting to pull container $REGISTRY_URL$PREFIX$image " >> $LOGFILE

# one line of work!  
## pull the image off the repositoray and tag it
  sudo docker pull $REGISTRY_URL$PREFIX$image
  sudo docker tag $REGISTRY_URL$PREFIX$image $PREFIX$image
##TODO check for the image ID and export it as a tar file

  
# Logging
  echo "Finished to build container $PREFIX$image " >> $LOGFILE
  date >> $LOGFILE
  popd
done

sudo docker images 
sudo docker images >> $LOGFILE

exit

#!/bin/bash

#
# kill every running container and remove them
#

echo "# kill every running container and remove them"

docker ps -aq | xargs docker kill &>/dev/null
docker ps -aq | xargs docker rm  &>/dev/null

#show what is left:
docker ps -a

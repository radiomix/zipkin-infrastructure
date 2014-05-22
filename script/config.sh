#!/bin/bash

#
# Configuration
#
# How we call the containers
IMG_PREFIX="elemica/zipkin-"

#Container name prefix
NAME_PREFIX="zipkin-"

# registry and port, we push to 
# my-registry.example.com:5000/  !! TRAILING FORWARDSLASH !! 
REGISTRY_URL=registry.im7.de:5000/
 
#Ports to be exposed between the containers
WEB_PORT="8080"
COLLECTOR_PORT="9410"
COLLECTOR_MGT_PORT="9900"
QUERY_PORT="9411"

ROOT_URL="http://deb.local:$PUBLIC_PORT"

#All containers
SERVICES=("cassandra" "collector" "query" "web" "fb-scribe")

#Log date
LOGDATE="date '+%F-%M-%S')"

#Author
AUTHOR="Elemica Script"

# Scripts to manipulate containers

This directory contains bash shel scripts to manipulate docker containers.
Each operation is logged locally into a logfile. We use different scripts, 
to perform the tasks. 

## Usage
Change into this directory and call the appropriate bash script to run the task.

###Variables

| Variable | Description | Note |
|---------|:---------:|:-------:|
|`LOGNAME`  | Name of the log file | Is written into this directory|
|`PREFIX`   | Prefix of the image/container | This is part of the repository name| 
|`REGISTRY_URL`| URL of the registry to push and pull the container | Needs a trailing forward slash `/`|
|`IMAGES` | String with the container names to be manipulated  | |

##`build.sh`
Builds all containers locally, tags them and pushes them into `REGISTRY_URL`.
##`pull.sh`
Pulls all containers from `REGISTRY_URL` and tags them locally.
##`stop.sh`
Cleans up old running containers and restarts them. It would be nice to be able to
rename containers easyly, but [ container renaming #3036 ](https://github.com/dotcloud/docker/issues/3036) 
does not describe a solution.
'stop.sh -s|--stop'  	stops containers
'stop.sh -c|--cleanup'  stops containers and removes them
'stop.sh container'	stop this container
'stop.sh -|--help'      this message

##`start.sh`
start.sh                 start all containers
start.sh  container       start this container
start.sh -h|--help       this message

##utils.sh 
This file contains all configuration variables and functions for container manipulations


# Scripts to manipulate containers

This directory contains bash shel scripts to manipulate docker containers.
Each operation is logged locally into a logfile. We use different scripts, 
to perform the tasks. 

## Prerequests
We expect, that the caller of these scripts is in the sudo group and we can call the `docker` 
command right from the command line. 

## Usage
Change into this directory and call the appropriate bash script to run the task.

###Variables
All configuration variables are combined in one file `config.sh` and read by `utils.sh`.

| Variable | Description | Note |
|---------|:---------:|:-------:|
|`LOGNAME`  | Name of the log file | Is written into this directory|
|`IMG_PREFIX`   | Prefix of the container in the repo | This is part of the repository name| 
|`NAME_PREFIX`   | Prefix of the container | This is part of the repository name| 
|`REGISTRY_URL`| URL of the registry to push and pull the container | Needs a trailing forward slash `/`|
|`SERVICES` | String with the container names to be manipulated  | |
|`LOGDATE`| Date part of the log file name| Used to log each container build process in a seperat file|
|`AUTHOR`|Author name| Used as a comment for registry pushes|
|`VERSION_LATEST`| Tag of the latest version|Used to tag the latest version of Container|
|`VERSION_PREVIOUS`| Tag of the previous version||

##build.sh
Builds all containers locally, tags them and pushes them into `REGISTRY_URL`.
##pull.sh
Pull fresh containers from `REGISTRY_URL` and tag them locally as *latest*.
##stop.sh
Cleans up old running containers and restarts them. It would be nice to be able to
rename containers easyly, but [ container renaming #3036 ](https://github.com/dotcloud/docker/issues/3036) 
does not describe a solution.
### Usage
```bash
stop.sh -s|--stop  	stops containers
stop.sh -c|--cleanup	stops containers and removes them
stop.sh container	stop this container
stop.sh -|--help	this message
```
##start.sh
### Usage
```bash
start.sh  --latest      start all containers tagged as latest
start.sh  --minus_one	start all containers tagged as minus_one 
start.sh -h|--help      this message
```

##utils.sh 
This file contains all configuration variables and functions for container manipulations


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
### Usage
```bash
build.sh -b|--base      build only base container
build.sh -z| --zipkin   build all zipkin containers 
build.sh -h|--help      this message
```
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

####TODO
 * After pushing a container to the repo, docker answers with the correct URL to review the tags for that image. 
  We need to remember this URL to later delete the container from the registry.

`    docker push registry.im7.de:5000/hello/world 
    The push refers to a repository [registry.im7.de:5000/hello/world] (len: 1)
    Sending image list
    Pushing repository registry.im7.de:5000/hello/world (1 tags)
    Image 511136ea3c5a already pushed, skipping
    Image 42eed7f1bf2a already pushed, skipping
    Image 120e218dd395 already pushed, skipping
    Image a9eb17255234 already pushed, skipping
    Image 25a64a992f61 already pushed, skipping
    Image 3b420170fc46 already pushed, skipping
    Image 82a51d5683a2 already pushed, skipping
    Pushing tag for rev [82a51d5683a2] on {http://registry.im7.de:5000/v1/repositories/hello/world/tags/latest} 
`
In order to delete the container from the registry, we have to delete both local containers `hello/world` and `registry.im7.de:5000/hello/world`, to inshure, docker does not remember locally, what image was pushed to the registry. 
We can then use the last URL to delete the container like this:
`url -X DELETE http://registry.im7.de:5000/v1/repositories/hello/world/`


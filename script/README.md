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
Builds containers locally and  tags them as `REGISTRY_URL`.
##push.sh
Push containers taged as *latest* to `REGISTRY_URL`.
##stop.sh
##pull.sh
Pull fresh containers from `REGISTRY_URL` and tag them locally as *latest*.
##stop.sh
Cleans up old running containers and restarts them. It would be nice to be able to
rename containers easyly, but [ container renaming #3036 ](https://github.com/dotcloud/docker/issues/3036) 
does not describe a solution.
##start.sh
##test.sh
Runs all scripts with all containers
##utils.sh 
This file contains all configuration variables and functions for container manipulations
##config.sh
This file contains variables to configure the bash scripts
 * After pushing a container to the repo, docker answers with the correct URL to review the tags for that image. 
  We need to remember this URL to later delete the container from the registry.

```   docker push registry.im7.de:5000/hello/world 
    Pushing tag for rev [82a51d5683a2] on {http://registry.im7.de:5000/v1/repositories/hello/world/tags/latest} 
```   
In order to delete the container from the registry, we have to delete both local containers `hello/world` and `registry.im7.de:5000/hello/world`, to inshure, docker does not remember locally, what image was pushed to the registry. 
We can then use the last URL to delete the container like this:
`url -X DELETE http://registry.im7.de:5000/v1/repositories/hello/world/`


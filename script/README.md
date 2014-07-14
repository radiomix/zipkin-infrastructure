# Scripts to manipulate containers

This directory contains bash shell scripts to manipulate docker containers.
Each operation is logged locally into a logfile. We use different scripts, 
to perform the tasks. 

## Prerequests
We expect, that the caller of these scripts is in the sudo group and we can call the `docker` 
command right from the command line. 

##Variables
All configuration variables are combined in one file `config.sh` and read by `utils.sh`.
###config.sh
This file contains variables to configure the bash scripts

| Variable | Description | Note |
|---------|:---------:|:-------:|
|`LOGNAME`  | Name of the log file | Is written into this directory|
|`IMG_PREFIX`   | Prefix of the container in the repo | This is part of the repository name| 
|`NAME_PREFIX`   | Prefix of the container | This is part of the repository name| 
|`REGISTRY_URL`| URL of the registry to push and pull the container | Needs a trailing forward slash `/`|
|`SERVICES` | String with the container names to be manipulated  | |
|`LOGDATE`| Date format| May be used to tag current container before pulling new one |
|`LOGDIR`| Log directory| Output is logged into this directory |
|`LOGFILE`| Log file name| Output is appended to this file in `LOGDIR`|
|`AUTHOR`|Author name| Used as a comment for registry pushes|
|`VERSION_LATEST`| Tag of the latest version|Used to tag the latest version of Container|
|`VERSION_PREVIOUS`| Tag of the previous version||
|`SILENT`| Toggle Logging| If set to true, nothing is logged into `LOGFILE`|
###utils.sh 
This file contains functions for container manipulations.

## Shell scripts
####  Usage
Change into this directory and call the appropriate bash script with a container name
as defined in  `SERVICES` to run the task.

#### Example
`./build.sh foo`

Any script provided with an argument that does not convert to a zipkin container does show the help message.
```
./build.sh foo
** ERROR :foo: NO Zipkin Service
** please provide a valid Zipkin Service: 
** base cassandra collector query web fb-scribe
Usage:
 ./build.sh base 
 ./build.sh cassandra 
 ./build.sh collector 
 ./build.sh query 
 ./build.sh web 
 ./build.sh fb-scribe 
** EXIT 

```
### build.sh
Builds a container and  tags it locally as `IMG_PREFIX`foo, where foo is a valid zipkin service.
### push.sh
Pushs a container taged as *latest* to `REGISTRY_URL`. If the registry is not reachable, the script echos an error.
### pull.sh
Pulls the container from `REGISTRY_URL` and tags it locally as *latest*.
###stop.sh
Stops a container. It would be nice to be able to
rename containers easyly, but [ container renaming #3036 ](https://github.com/dotcloud/docker/issues/3036) 
does not describe a solution.
###start.sh
Checks, if a container of this name is runnung and if not, start this container.
####cleanup.sh
Kills and removes a container.
####delete.sh
Tries to delete a container from `REGISTRY_URL` and locally.

#### Workaround to delete a container from the repository
After pushing a container to the repo, docker answers with the correct URL to review the tags for that image. 
  We need to remember this URL to later delete the container from the registry.

``` 
docker push registry.example.com:5000/hello/world 
The push refers to a repository [registry.example.com:5000/hello/world] (len: 1)
Sending image list
Pushing repository registry.example.com:5000/hello/world (1 tags)
Image 511136ea3c5a already pushed, skipping
Image 42eed7f1bf2a already pushed, skipping
Image 120e218dd395 already pushed, skipping
Image a9eb17255234 already pushed, skipping
Image 25a64a992f61 already pushed, skipping
Image 3b420170fc46 already pushed, skipping
Image 82a51d5683a2 already pushed, skipping
Pushing tag for rev [82a51d5683a2] on {http://registry.example.com:5000/v1/repositories/hello/world/tags/latest} 
```
In order to delete container `registry.example.com:5000/hello/world` from the registry, we have to delete both local container `hello/world` and `registry.example.com:5000/hello/world`, to inshure, docker does not remember locally, what image was pushed to the registry. 
We can then use the last URL to delete the container like this:

`curl -X DELETE http://registry.example.com:5000/v1/repositories/hello/world/`

###Test
####test.sh
Runs all scripts with all containers. 
#####TODO
* Evaluate the test results.

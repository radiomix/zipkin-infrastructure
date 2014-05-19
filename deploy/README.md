# Tools to manipulate containers

This directory contains bash shel scripts to manipulate docker containers.
Each operation is logged locally into a logfile. We use different scripts, 
to perform the tasks. 

## Usage
Change into this directory and call the appropriate bash script to run the task.

##Variables

| Variable | Description |
|---------|---------|
|`LOGNAME`  | Name of the log file |
|`PREFIX`   | Prefix of the image/container |
|`REGISTRY_URL`| URL of the registry to push and pull the container |
|`IMAGES` | String with the container names to be manipulated  |

##`build.sh`
Builds all containers locally, tags them and pushes them into `REGISTRY_URL`.
##`pull.sh`
Pulls all containers from `REGISTRY_URL` and tags them locally.
##`deploy.sh`
Cleans up old running containers and restarts them.

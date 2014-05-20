# Docker Zipkin-Base Image

This is the base container used as a starting point to create the actual Zipkin service images for
collector, query, and web.

### Dockerfile
We install git and scala and compile the compile the unconfigured scala app completely.
### Note
On an AWS AMI of type 't1.micro' RAM was not enough to compile the basic zipkin package.
Launching an instance of type 'm3.medium' with 16GB HDD did the job. It will take about between 
15 and 30 minutes to build the base container on an 2GHz CPU depending on the amount of memory.
The container will have a size of about 700MB.

## Sources 
This work is inspired by [Markus Fix](https://github.com/lispmeister/docker-zipkin/blob/master/README.md)

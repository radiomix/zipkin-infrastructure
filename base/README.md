# Docker Zipkin-Base Image

This is the base image used to create the actual Zipkin service images for
collector, query, and web.

## Note
On an AWS AMI of type 't1.micro' RAM was not enough to compile the basic zipkin package.
Launching an instance of type 'm3.medium' with 16GB HDD did the job.

# Inspired by
For more details have a look at:

<https://github.com/lispmeister/docker-zipkin/blob/master/README.md>


zipkin-infrastructure
=====================

All components needed to run Zipkin in Docker containers (Cassandra, Collector, Query, Web, and FB-Scribe)
We build a Zipkin base container installing scala and zipkin collector, query and web respectively.
From this docker image, we derive the specifig zipkin parts to combine a zipkin infrastructure.
Directorey fb-scribe will generate a facebook [scribe](https://github.com/facebookarchive/scribe) service 
ready to communicat with zipkin collector. The same functionallity can be obtained by using a [Scala Akka Tracing](https://github.com/levkhomich/akka-tracing) mechanism.
 

### Directory structure

 * Directory [base](https://github.com/elemica/zipkin-infrastructure/tree/master/base) generates a docker container for
 * Directory [cassandra](https://github.com/elemica/zipkin-infrastructure/tree/master/cassandra) generates a docker container for
 * Directory [collector](https://github.com/elemica/zipkin-infrastructure/tree/master/collector) generates a docker container for
 * Directory [query](https://github.com/elemica/zipkin-infrastructure/tree/master/query) generates a docker container for
 * Directory [web](https://github.com/elemica/zipkin-infrastructure/tree/master/web) generates a docker container for
 * Directory [script](https://github.com/elemica/zipkin-infrastructure/tree/master/script) generates a docker container for


#### Notes

Docker-Zipkin starts the services in their own container: zipkin-cassandra,
zipkin-collector, zipkin-query, zipkin-web and only link required dependencies
together.

The started Zipkin instance would be backed by a single node Cassandra. By
default, the collector port is not mapped to public. You will need to link
containers that you wish to trace with zipkin-collector or you may change the
respective line in deploy.sh to map the port.

All images with the exception of zipkin-cassandra are sharing a base image:
[base](https://github.com/elemica/zipkin-infrastructure/tree/master/base). zipkin-base and zipkin-cassandra are built on ubuntu:12.04.

Once the containers are running you can connect to the collector on
port 9410 via akka-tracing or other libraries that support Zipkin tracing.
<https://github.com/levkhomich/akka-tracing>

### Dockerfile
We try to place as many installation commands into Docker files, to ease the build process:
 * Each build step is frozen as an intermediate container
 * Errors during build don`t require rerunning it completely
 * Testing new install instaructions start from a partly build process and thus run faster


### Source
This repo is cloned form [https://github.com/lispmeister/docker-zipkin.git](https://github.com/lispmeister/docker-zipkin.git) 

### Authors

Zero Cho <itszero@gmail.com>

Markus Fix <lispmeister@gmail.com>

Michael Klöckner <mkl@im7.de>

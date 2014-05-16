FROM debian:sid
MAINTAINER Markus Fix "http://deeprecursion.com"

RUN apt-get update
RUN apt-get install -y git curl
RUN apt-get install -y scala 
RUN git clone https://github.com/twitter/zipkin.git

# Split the next compile job into three steps for memory reasons 
# On a AWS micro t1.micro instance
RUN (cd zipkin; bin/sbt compile)
#
#RUN (cd zipkin; bin/collector)
#RUN (cd zipkin; bin/query)
#RUN (cd zipkin; bin/web)

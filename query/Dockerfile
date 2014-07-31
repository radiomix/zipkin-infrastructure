FROM elemica/zipkin-base
MAINTAINER Markus Fix "http://deeprecursion.com"

ADD run.sh /usr/local/bin/run

# run command in  bash to be able 
# to put it into background if attaching to the container
# command runs in foreground, but with a bash shell!!
CMD ["/bin/bash", "/usr/local/bin/run"]

EXPOSE 9411

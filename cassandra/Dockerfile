FROM elemica/zipkin-base
MAINTAINER Markus Fix "http://deeprecursion.com"

ADD install.sh /usr/local/bin/install
RUN /usr/local/bin/install
RUN (rm -f /etc/mtab; ln -s /proc/mounts /etc/mtab)
ADD run.sh /usr/local/bin/run

# run command in  bash to be able 
# to put it into background if attaching to the container
# command runs in foreground, but with a bash shell!!
CMD ["/bin/bash", "/usr/local/bin/run"]

EXPOSE 9160 7000 7001 9042 7199

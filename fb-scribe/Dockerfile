#
# Dockerfile - Facebook Scribed
#
# Source:	Yongbok Kim <ruo91@yongbok.net>

FROM     	elemica/zipkin-base
MAINTAINER 	Michael Klöckner <mkl AT im7 DOT de>

# Last Package Update & Install
RUN apt-get update && apt-get install -y curl supervisor openssh-server net-tools iputils-ping nano \
 make autoconf automake flex bison libtool libevent-dev pkg-config libssl-dev libboost-all-dev libbz2-dev build-essential g++ python-dev git

# Facebook Scribe
# Thrift
WORKDIR /usr/local/src
RUN git clone https://github.com/apache/thrift.git 
WORKDIR /usr/local/src/thrift
RUN git fetch && git checkout 0.9.1 
RUN ./bootstrap.sh 
RUN ./configure 
RUN make 
RUN make install

# fb303
WORKDIR /usr/local/src/thrift/contrib/fb303 
RUN ./bootstrap.sh 
RUN ./configure CPPFLAGS="-DHAVE_INTTYPES_H -DHAVE_NETINET_IN_H" \
RUN make 
RUN make install

# fb303 python module
WORKDIR /usr/local/src/thrift/lib/py 
RUN python setup.py install 
WORKDIR /usr/local/src/thrift/contrib/fb303/py 
RUN python setup.py install

# Scribe
WORKDIR /usr/local/src/
RUN git clone https://github.com/facebook/scribe.git
WORKDIR /usr/local/src/scribe
RUN ./bootstrap.sh 
RUN ./configure CPPFLAGS="-DHAVE_INTTYPES_H -DHAVE_NETINET_IN_H -DBOOST_FILESYSTEM_VERSION=2" LIBS="-lboost_system -lboost_filesystem" 
RUN make 
RUN make install

# ENV
ENV LD_LIBRARY_PATH /usr/local/lib
RUN echo "export LD_LIBRARY_PATH=/usr/local/lib" >> /etc/profile

# Scribe python module
WORKDIR /usr/local/src/scribe/lib/py 
RUN python setup.py install

##TODO configrue scribe

# Port
EXPOSE 22 1463

# Daemon
CMD ["/usr/bin/supervisord"]

#!/bin/bash 

#
# source https://github.com/elemica/elemica2-operations/blob/master/docker/zipkin-scribed-docker.pdf
#

apt-get update
apt-get install -y make flex bison libtool libevent-dev automake
apt-get install -y pkg-config libssl-dev libboost-all-dev libbz2-dev
apt-get install -y build-essential g++ python-dev git
apt-get install -y openjdk-6-jdk ant
cd /var/tmp
git clone https://github.com/apache/thrift.git
cd thrift
git fetch
git checkout 0.9.x
./bootstrap.sh
./configure
make
make install
cd tutorial/
thrift -r -v --gen cpp tutorial.thrift
cd ../contrib/
cd fb303/
./bootstrap.sh
./configure CPPFLAGS="-DHAVE_INTTYPES_H -DHAVE_NETINET_IN_H"
make
make install
cd ../../
cd lib
cd py
python setup.py install
cd ../../
cd contrib/fb303/py
python setup.py install
python -c 'import thrift' ; python -c 'import fb303'
cd ../../../
cd ..
git clone https://github.com/facebook/scribe.git
cd scribe/
./bootstrap.sh
./configure CPPFLAGS="-DHAVE_INTTYPES_H -DHAVE_NETINET_IN_H -DBOOST_FILESYSTEM_VERSION=2" \
LIBS="-lboost_system -lboost_filesystem"
make
make install
export LD_LIBRARY_PATH=/usr/local/lib
cd lib/py
python setup.py install
python -c 'import scribe'
ldconfig
cd /var/tmp
rm -rf scribe thrift


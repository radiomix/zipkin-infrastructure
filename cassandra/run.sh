#!/bin/sh
IP=`hostname --ip-address`
echo "***My IP: $IP"

CONFIG_TMPL="/etc/cassandra/cassandra.default.yaml"
CONFIG="/etc/cassandra/cassandra.yaml"
rm $CONFIG; cp $CONFIG_TMPL $CONFIG
sed -i -e "s/^listen_address.*/listen_address: $IP/" $CONFIG
sed -i -e "s/^rpc_address.*/rpc_address: 0.0.0.0/" $CONFIG

echo "*** My Config:"
cat $CONFIG

echo "*** Cleaning up log files"
rm -v /var/log/cassandra/*

echo "*** Starting Cassandra"
/etc/init.d/cassandra start

echo "*** Wait for Cassandra to boot"
until grep -m1 -q "9160" /var/log/cassandra/system.log
do
  echo "..Wait for Cassandra"
  sleep 2
done
echo "**** Cassandra is live!"

echo "*** Importing Schema"
cassandra-cli -host localhost -port 9160 -f /etc/cassandra/cassandra-schema.txt
echo "*** Stopping Cassandra"
/etc/init.d/cassandra stop

echo "*** Starting Cassandra in Foreground"
/usr/sbin/cassandra -f






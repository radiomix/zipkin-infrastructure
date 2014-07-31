# Cassandra for Zipkin

This is the image for a single node Cassandra database used
by Zipkin collector and Zipkin query.

### Ports

*Ports exposed through Dockerfiles*

| Container| Port|  Description |
|:---------|:---------|:-------|         
| `zipkin-cassandra`| 9160| [Thrift client API](http://wiki.apache.org/cassandra/FAQ#ports) for RPC|          
| `zipkin-cassandra`| 7000| [Gossip](http://wiki.apache.org/cassandra/FAQ#ports) to find other cassandra instanced in the cluster|
| `zipkin-cassandra`| 7001| [Gossip](http://wiki.apache.org/cassandra/FAQ#ports) with SSL |
| `zipkin-cassandra`| 9042| [CQL](http://stackoverflow.com/questions/2359159/cassandra-port-usage-how-are-the-ports-used) Cassandra Query Language|
| `zipkin-cassandra`| 7199| [JMX](http://wiki.apache.org/cassandra/JmxInterface) to view and tweak variables which it exposes via [Java Management Extension](http://java.sun.com/javase/technologies/core/mntr-mgmt/javamanagement/) |

#### AWS security group
As cassandra uses many ports a possible AWS security group is described by [DATASTAX](http://www.datastax.com/documentation/cassandra/2.0/cassandra/install/installAMISecurityGroup.html).

#####FIXME
- As the install script calls `gpg` communicating over port 11371, we have to make shure, this port is open inbound on the build host, and on the NAT-Server inbout as well as outbound.
- File `/etc/init.d/cassandra` inside the container, which starts the proccess, generates errors:
- It tries to set memory limit as unlimited. This generates an error: `ulimit: operation not permitted` 
- Starting cassandra after uncommenting 'ulimit', we get error: 
`set_caps(CAPS) failed for user 'cassandra'
Service exit with a return value of 4`
We therfore used '/usr/sbin/cassandra' to start the daemon in [run.sh](run.sh).
#### Source
For more details have a look at:
<https://github.com/lispmeister/docker-zipkin/blob/master/README.md>

### Zipkin Port Structure
As we store the tracing data in a cassandra DB, we first of all start this container naming it `zipkin-cassandra` as defined by `NAME_PRFIX` in [config.sh](https://github.com/elemica/zipkin-infrastructure/blob/master/script/config.sh) and link  `zipkin-collector`, `zipkin-query` and `zipkin-web` to it.
All ports we use are defined in  [config.sh](https://github.com/elemica/zipkin-infrastructure/blob/master/script/config.sh).

*Ports exposed through shell scripts*

| Variable| Port| Exposed by | Description |
|:---------|:---------|:-------|:-------|
| `COLLECTOR_PORT`| 9410| `zipkin-collector`| linked internally to talk to `zipkin-cassandra`|
| `COLLECTOR_MGT_PORT`| 9900 | `zipkin-collector`| linked internally to talk to `zipkin-cassandra`|
| `QUERY_PORT` | 9411|  `zipkin-query`| linked internally to talk to `zipkin-cassandra`|
| `WEB_PORT`| 8080| `zipkin-web`| to be accessed by a browser to surf the zipkin web UI|

*Ports exposed through Dockerfiles*
 
| Container| Port|  Description |
|:---------|:---------|:-------|
| `zipkin-cassandra`| 9160| [Thrift client API](http://wiki.apache.org/cassandra/FAQ#ports) for RPC|   
| `zipkin-cassandra`| 7000| [Gossip](http://wiki.apache.org/cassandra/FAQ#ports) to find other cassandra instanced in the cluster|
| `zipkin-cassandra`| 7001| [Gossip](http://wiki.apache.org/cassandra/FAQ#ports) with SSL |
| `zipkin-cassandra`| 9042| [CQL](http://stackoverflow.com/questions/2359159/cassandra-port-usage-how-are-the-ports-used) Cassandra Query Language|
| `zipkin-cassandra`| 7199| [JMX](http://wiki.apache.org/cassandra/JmxInterface) to view and tweak variables which it exposes via [Java Management Extension](http://java.sun.com/javase/technologies/core/mntr-mgmt/javamanagement/) |
| `zipkin-collector`| 9410| listening for tracing messages, written by `fb-scribe` or an AKKA application |
| `zipkin-collector`| 9900|  management port to manage `zipkin-collector`| 
| `zipkin-query`| 9411| [Query Service](https://github.com/twitter/zipkin/search?q=9411&type=Code) port for the query service to listen on |
| `zipkin-web`| 8080| [Web Frontend](https://github.com/twitter/zipkin/search?q=8080&ref=cmdform) port for the zipkin web front end |
| `zipkin-fb-scribe`| 22|  |
| `zipkin-fb-scribe`| 1463|  listening for spans for the tracing messages|



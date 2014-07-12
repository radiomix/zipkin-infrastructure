# Zipkin Collector

This is the image for the Zipkin Collector, recieving tracing messages form fb-scribe or an AKKA-tracing mechanism.

#### Ports

*Ports exposed through shell scripts*

| Variable| Port| Exposed by | Description |
|:---------|:---------|:-------|:-------|
| `COLLECTOR_PORT`| 9410| `zipkin-collector`| linked internally to talk to `zipkin-cassandra`|
| `COLLECTOR_MGT_PORT`| 9900 | `zipkin-collector`| linked internally to talk to `zipkin-cassandra`|


*Ports exposed through Dockerfiles*

| Container| Port|  Description |
|:---------|:---------|:-------|         
| `zipkin-collector`| 9410| listening for tracing messages, written by `fb-scribe` or an AKKA application |
| `zipkin-collector`| 9900|  management port to manage `zipkin-collector`| 



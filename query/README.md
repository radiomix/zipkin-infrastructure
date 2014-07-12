# Zipkin Query

This is the image for Zipkin Query communicating with Zipkin cassandra and Zipkin Web.

#### Ports 
*Ports exposed through shell scripts*

| Variable| Port| Exposed by | Description |
|:---------|:---------|:-------|:-------|
| `QUERY_PORT` | 9411|  `zipkin-query`| linked internally to talk to `zipkin-cassandra`|

*Ports exposed through Dockerfiles*

| Container| Port|  Description |
|:---------|:---------|:-------|         
| `zipkin-query`| 9411| [Query Service](https://github.com/twitter/zipkin/search?q=9411&type=Code) port for the query service to listen on |



For more details have a look at:
<https://github.com/lispmeister/docker-zipkin/blob/master/README.md>

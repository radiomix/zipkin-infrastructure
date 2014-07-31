# Zipkin Web

This is the image for Zipkin Web, the Zipkin Web Frontend.

#### Ports

*Ports exposed through shell scripts*

| Variable| Port| Exposed by | Description |
|:---------|:---------|:-------|:-------|
| `WEB_PORT`| 8080| `zipkin-web`| to be accessed by a browser to surf the zipkin web UI|


*Ports exposed through Dockerfiles*

| Container| Port|  Description |
|:---------|:---------|:-------|         
| `zipkin-web`| 8080| [Web Frontend](https://github.com/twitter/zipkin/search?q=8080&ref=cmdform) port for the zipkin web front end |

#### Zipkin Web
The zipkin base container just installs zipkin files, by cloning the the twitter github repo.
From this image we build the web container. We find directory `/zipkin/zipkin-web/dist/zipkin-web` containing the zipkin-web jar files.
Typing within the container `java -cp libs/ -jar zipkin-web-1.2.0-SNAPSHOT.jar -help`  gives the possible options for running the jar file.

```
  -admin.port=':9990': Admin http server port
  -help='false': Show this help
  -log.append='true': If true, appends to existing logfile. Otherwise, file is truncated.
  -log.level='INFO': Log level
  -log.output='/dev/stderr': Output file
  -log.rollPolicy='Never': When or how frequently to roll the logfile. See com.twitter.logging.Policy#parse documentation for DSL details.
  -log.rotateCount='-1': How many rotated logfiles to keep around
  -zipkin.web.cacheResources='false': cache static resources and mustache templates
  -zipkin.web.pinTtl='30.days': Length of time pinned traces should exist
  -zipkin.web.port=':8080': Listening port for the zipkin web frontend
  -zipkin.web.query.dest='127.0.0.1:9411': Location of the query server
  -zipkin.web.resourcesRoot='zipkin-web/src/main/resources': on-disk location of resources
  -zipkin.web.rootUrl='http://localhost:8080/': Url where the service is located
global flags:
  -com.twitter.finagle.exception.host='localhost:1463': Host to scribe exception messages
  -com.twitter.finagle.exp.scheduler='local': Which scheduler to use for futures <local> | <lifo> | <bridged>[:<num workers>] | <forkjoin>[:<num workers>]
  -com.twitter.finagle.loadbalancer.defaultBalancer='heap': Default load balancer
  -com.twitter.finagle.netty3.numWorkers='2': Size of netty3 worker pool
  -com.twitter.finagle.serverset2.chatty='false': Log resolved ServerSet2 addresses
  -com.twitter.finagle.serverset2.client.chatty='false': Track ZooKeeper calls and responses
  -com.twitter.finagle.stats.ostrichFilterRegex='': Ostrich filter regex
  -com.twitter.finagle.tracing.debugTrace='false': Print all traces to the console.
  -com.twitter.finagle.zipkin.host='localhost:1463': Host to scribe traces to
  -com.twitter.finagle.zipkin.initialSampleRate='0.001': Initial sample rate
  -com.twitter.jvm.numProcs='1.0': number of logical cores
  -com.twitter.newZk='false': Use the new ZooKeeper implementation for /$/com.twitter.serverset
  -com.twitter.server.announcerMap='': A list mapping service names to announcers (gizmoduck=zk!/gizmoduck)
  -com.twitter.server.resolverMap='': A list mapping service names to resolvers (gizmoduck=zk!/gizmoduck)
  -socksPassword='': SOCKS password
  -socksProxyHost='': SOCKS proxy host
  -socksProxyPort='0': SOCKS proxy port
  -socksUsername='': SOCKS username
```

For more details have a look at:
<https://github.com/lispmeister/docker-zipkin/blob/master/README.md>

# Facebook's Scribe for Zipkin

This is the image for a single Facebook Scribe node 
to be used by the Zipkin collector image.

## Ports
Zipkin configures a scribe client in [scribe-client.conf](https://github.com/twitter/zipkin/blob/1.1.0/zipkin-redis/config/scribe-client.conf).

*Ports exposed through Dockerfiles*

| Container| Port|  Description |
|:---------|:---------|:-------|         
| `zipkin-fb-scribe`| 22|  | 
| `zipkin-fb-scribe`| 1463|  listening for spans for the tracing messages| 

#### Notes
The container starts with the following configuration: It listens on port 1436 for tracing messages and writes them to the container directory /tmp/scribetest.
The container can be accessed via ssh on port 10022 beeing mapped internally to the ssh port 22. Login: root with password 'scribe' is accepted!

## Thanks
[gist to install scribe](https://gist.github.com/elprup/5642303)
[Install scribe from source](https://github.com/huandu/huandu.github.io/blob/master/_posts/2014-03-04-install-facebookscribe-from-source.md)

## changelog
* 2014-05-19 
* 2014-07-11 Added Zipkin documentation link

# Facebook's Scribe for Zipkin

This is the image for a single Facebook Scribe node 
to be used by the Zipkin collector image.

## Ports
Zipkin configures a scribe client in [scribe-client.conf](https://github.com/twitter/zipkin/blob/1.1.0/zipkin-redis/config/scribe-client.conf).

## Notes
Building the scribe container takes between 10 and 15 minutes on a 2GHz CPU depending on the memory available.
The resulting image is about 800MB.
## Thanks
[gist to install scribe](https://gist.github.com/elprup/5642303)
[Install scribe from source](https://github.com/huandu/huandu.github.io/blob/master/_posts/2014-03-04-install-facebookscribe-from-source.md)

## changelog
* 2014-05-19 
* 2014-07-11 Added Zipkin documentation link

# reverse-proxy

This repo contains instructions and tools for setting up an nginx reverse proxy to route HTTPS-protected external traffic to HTTP (or HTTPS) handler endpoints internal to your network.  It uses a simple docker container with nginx + certbot, and runs certbot command with `docker exec` while the container is running.

## Prerequisites

This tool assumes you have:

* One or more domains registered with ANAMEs directed to your external IP address
* One or more handler servers on your internal network serving HTTP or HTTPS on one or more ports
* Directed all port 80 and port 443 traffic to the machine on which this reverse proxy will be run
* Installed docker on the machine on which this reverse proxy will be run

## Setup

On the machine the reverse proxy will run on:

* Clone this repository
* Configure reverse_proxy.conf: copy `./nginx/conf/reverse_proxy.conf.example` to `./nginx/conf/reverse_proxy.confg` and edit to describe how to link external hostnames to the appropriate internal network services
* (optional) Build docker image: run the `docker build` command in the comments of `Dockerfile` to build the `reverse_proxy` image
* Start container: run `./reverse_proxy.sh` from this working directory
* Verify that `http://<your external server>` is routed to the appropriate handler
* Copy `./nginx/conf/reverse_proxy.conf` to `./nginx/conf/reverse_proxy.original`
* Get initial certs: run `./get_first_certs.sh`; this will prompt for some information and change the nginx configuration in the container
* Verify that `https://<your external server>` is routed to the appropriate handler

At this point, the docker container running the reverse proxy will restart automatically if the system is rebooted.

## Auto-renewal

Let's Encrypt certificates expire after 90 days.  To set up your system to automatically renew them:

* `crontab -l | { cat; echo "0 1,13 * * * $PWD/renew_certs.sh >> $PWD/cert_renewals.log 2>&1"; } | crontab -`

This triggers a renewal check once every 12 hours.  Note that this crontab entry can be removed with `crontab -e`.

## Troubleshooting

### The container name "/reverseproxy" is already in use

* `docker container kill reverseproxy`
* `docker container rm reverseproxy`

### HTTP site cannot be reached in Chrome

If you previously browsed, e.g., example.com using https (i.e.: https://example.com) then later try to browse it using http (i.e.: http://example.com), Chrome will indicate "This site can't be reached" and "example.com refused to connect".  To fix this, open an incognito window and then navigate to http://example.com.

### Enabling more verbose nginx logs

* Open a bash command line in the docker container running the nginx reverse proxy: ` docker container exec -it reverseproxy /bin/bash`
* Install nano: `apt-get install nano`
* Edit nginx.conf: `nano /etc/nginx/nginx.conf`
* Change the error_log as desired, probably `warn` to `info`
* Save and exit nano
* `nginx -s reload`
* Exit bash command line and then `docker container logs reverseproxy --follow`

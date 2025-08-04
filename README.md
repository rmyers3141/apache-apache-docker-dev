# apache-http-docker-dev
Creation of a custom Docker image for Apache HTTP Server 2.4.x

## Overview
I have developed a `Dockerfile` to build a custom Docker image for **Apache HTTP Server v2.4**, (hereafter referred to just as *"Apache"*).

The custom Apache `*.conf` files supports SSL and includes a reverse-proxy configuration to support sending traffic to some back-end Tomcat instances (for use in another project).

This Docker image has been verified as working both standalone and in a Docker Swarm clustered configuration (with the back-end Tomcat instances).

## Prerequisites
Before using the `Dockerfile` to create a Docker image, you will need:

- [x] A host machine (preferably Linux) running a current version of Docker.

- [x] A user account on the host machine with the ability to run `docker` commands (this may require `sudo`).

- [x] The ability to download the official Apache HTTP Server Docker image **httpd:2.4** base image to the host machine.

- [x] The accompanying SSL configuration files (`my-ssl-rp.conf`,`web.domain12c.test.crt`, `web.domain12c.test.key`, `CA.cert.pem`) configures the Apache with a private CA-signed certificate identity `CN=web.domain12c.test` in a test domain `.domain12c.test`.  So add the alias name `web.domain12c.test` to the `/etc/hosts` of your host machine, as well as all the remote machines from which you intend to access the Apache instance from so that remote access is possible.   If you use a DNS server, update that server appropriately with the alias hostname.


## Docker Image Creation
First create a new directory on your host machine, such as `~/apache-build`.

Upload the following files and directories to this directory:

- `Dockerfile`
- `config/` directory and it's contents (replace these with your own custom versions if desired)

Once uploaded, change to the directory `~/apache-build`.  The directory listing should look something like the following:

```sh
$ ls
config  Dockerfile
```

Make sure you are in the directory where the `Dockerfile` (and accompanying files) exist and build the Docker image using the command:

```sh
$ docker build -t my-apache2:v1.0 .
```
This will build a Docker image with the name and tag `my-apache2:v1.0`, but you can choose a different name and tag if desired.

## Run a Container based on the Docker Image
Once the image has been created, test that it works satisfactorily by running an interactive container based on it with a command such as the following:
```sh
$ docker run -it --name my-httpd -p 8080:80 -p 7443:443 my-apache2:v1.0
```
This assigns the name `my-httpd` to the running container, maps the exposed internal Apache ports 80, 443 to the external ports 8080, 7443 respectively, and starts an interactive session.

If you have assigned an alias of `web.domain12.test` to your host machine, you can verify the Apache container is working by visiting the URLs:

- http://web.domain12c.test:8080 
- https://web.domain12c.test:7443/


Inside the interactive container session, you can run the Apache shutdown script `apachectl stop` to shutdown the Apache web server and stop the container.

## Background Notes
### Motivation
This is development project to construct a custom Apache HTTP Server Docker image with SSL support to act as a reverse-proxy to some back-end Tomcat instances.


### Overview of the `Dockerfile`
In summary, the `Dockerfile` builds an image by doing the following: - 

1. Begins image creation with the official Apache HTTP Server 2.4 base image **httpd:2.4** ; as no tag is specified the `latest` image will be pulled.

2. Copies the custom Apache configuration from `config/` to `/usr/local/apache2/conf/` in the base image.



### TO-DO:
This is a very basic `Dockerfile` construction and could benefit from many improvements.  However, these will depend on any evolving project requirements.


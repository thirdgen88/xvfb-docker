# Supported tags and respective `Dockerfile` links

* [`latest` (Dockerfile)](https://github.com/thirdgen88/xvfb-docker/blob/master/Dockerfile)

# Quick Reference

* **Where to file issues**:
https://github.com/thirdgen88/xvfb-docker/issues

* **Maintained by**:
Kevin Collins

* **Supported architectures**:
`amd64`

* **Source of this description**:
https://github.com/thirdgen88/xvfb-docker/tree/master/docs ([History](https://github.com/thirdgen88/xvfb-docker/commits/master/docs))

# Overview

This Docker image is intended to be used as a sidecar image for the Ignition on Docker (see the [kcollins/ignition](https://hub.docker.com/r/kcollins/ignition), for example) in order to enable successful use of the Mobile Module.

# Getting Started

The easiest way to use this image is with a Docker Compose (or similar) implementation.  Ultimately, it works by having a shared volume between the containers where the Xvfb X11 socket is created and then used.

This section will show you how to use the image with standard docker usage.

## Running Xvfb and Ignition

First, create a [named volume](https://docs.docker.com/storage/volumes/) that will be used to share the X11 socket:

	$ docker volume create xvfb_x11

Next, start the container with a simple volume mount:

	$ docker run -v xvfb_x11:/tmp/.X11-unix kcollins/xvfb:latest

Start your Ignition Gateway, sharing that same volume (keep in mind that this example doesn't use a volume for the gateway data itself and should be considered as just a simple example to demonstrate usage):

	$ docker run -p 8088:8088 -v xvfb_x11:/tmp/.X11-unix kcollins/ignition:latest

Finally, open the configuration section of the Gateway webpage and go to the _Mobile->Settings_ area.  In the Environment Variables section, put `DISPLAY=:8` and save the changes.

At this point, if you open a mobile device against the gateway address (http://localhost:8088 in our example), you will see the mobile project (once you've created one in the Ignition Designer) launch and render!

# Using Docker Compose

Below is a simple _docker-compose_ example that demonstrates the guidance above in a nicer package:

```yaml
version: '3'
services:
  gateway:
    image: kcollins/ignition:7.9.10
    volumes:
      - gateway_data:/var/lib/ignition
      - x11:/tmp/.X11-unix
    ports:
      - 8088:8088
  xvfb:
    image: kcollins/xvfb:latest
    volumes:
      - x11:/tmp/.X11-unix

volumes:
  gateway_data:
  x11:
```

## Running the Docker Compose Services

To bring up the Docker Compose services, use the following command to launch in detached mode and then view the logs:

    $ docker-compose up -d && docker-compose logs -f

You can `Ctrl-C` safely out of the log view without shutting down your container.  If you wish to shut it down your container/service:

    $ docker-compose down

Note that at this point, your data is still preserved in a named volume.  If you wish to remove volumes as well during shutdown use the `-v` option.  **USE WITH CAUTION**

# License

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
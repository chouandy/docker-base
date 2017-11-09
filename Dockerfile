FROM phusion/baseimage:0.9.22
MAINTAINER ChouAndy
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

RUN curl -fsSL get.docker.com -o get-docker.sh \
 && sh get-docker.sh \
 && rm get-docker.sh

RUN curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
 && chmod +x /usr/local/bin/docker-compose

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

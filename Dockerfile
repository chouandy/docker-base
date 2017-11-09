FROM phusion/baseimage:0.9.22
MAINTAINER ChouAndy
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

RUN curl -fsSL get.docker.com -o get-docker.sh \
 && sh get-docker.sh \
 && rm get-docker.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

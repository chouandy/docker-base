FROM phusion/baseimage:0.11
LABEL maintainer=chouandy

ENV DEBIAN_FRONTEND=noninteractive
ENV DOCKER_VERSION=5:19.03.4~3-0~ubuntu-bionic

# Upgrade Packages
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

# Install Packages
RUN apt-get update && apt-get install -y \
  build-essential \
  pkg-config \
  git \
  tzdata

# # Install AWS Cli
RUN apt-get install -y python-dev
RUN curl 'https://bootstrap.pypa.io/get-pip.py' -o 'get-pip.py'
RUN python get-pip.py
RUN pip install awscli
RUN rm -f get-pip.py

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
RUN apt-get update && apt-get install -y \
  docker-ce=$DOCKER_VERSION \
  docker-ce-cli=$DOCKER_VERSION \
  containerd.io

# Install docker-compose
RUN curl -sLo /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` \
 && chmod +x /usr/local/bin/docker-compose

# Install go
ENV GOLANG_VERSION=1.13.4
RUN curl -sLo go.tar.gz https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz \
 && tar -C /usr/local -xzf go.tar.gz \
 && rm go.tar.gz
ENV GOPATH=/go
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
RUN curl https://glide.sh/get | sh

# Finalize
RUN apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

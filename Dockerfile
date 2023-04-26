FROM phusion/baseimage:jammy-1.0.1
LABEL maintainer=chouandy

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update && apt-get install -y \
  build-essential \
  pkg-config \
  git \
  tzdata

# Install aws cli
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py
RUN pip3 install awscli
RUN rm -f get-pip.py

# Install Docker
ENV DOCKER_VERSION=5:20.10.17~3-0~ubuntu-jammy
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update && apt-get install -y \
  docker-ce=$DOCKER_VERSION \
  docker-ce-cli=$DOCKER_VERSION \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

# Install go
ENV GOLANG_VERSION=1.20.3
RUN curl -sLo go.tar.gz https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz \
 && tar -C /usr/local -xzf go.tar.gz \
 && rm go.tar.gz
ENV GOPATH=/go
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# Finalize
RUN apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

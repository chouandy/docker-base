FROM buildpack-deps:jessie-scm

# Install docker
RUN curl -sSL https://get.docker.com/ | sh

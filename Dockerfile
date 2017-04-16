FROM buildpack-deps:jessie-scm

# Install docker
COPY install-docker /install-docker
RUN chmod +x /install-docker
RUN DOCKER_VERSION=1.12.6 /install-docker

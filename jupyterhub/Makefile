# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

include .env

.DEFAULT_GOAL=build

network:
	@docker network inspect $(DOCKER_NETWORK_NAME) >/dev/null 2>&1 || docker network create $(DOCKER_NETWORK_NAME)

volumes:
	@docker volume inspect $(DATA_VOLUME_HOST) >/dev/null 2>&1 || docker volume create --name $(DATA_VOLUME_HOST)
	@docker volume inspect $(DB_VOLUME_HOST) >/dev/null 2>&1 || docker volume create --name $(DB_VOLUME_HOST)

self-signed-cert:
	# make a self-signed cert

secrets/postgres.env:
	@echo "Generating postgres password in $@"
	@echo "POSTGRES_PASSWORD=$(shell openssl rand -hex 32)" > $@

secrets/oauth.env:
	@echo "oauth.env file is missing! Did you create and configure the GitHub OAuth integration?"
	@exit 1

secrets/jupyterhub.crt:
	@echo "TLS certificates are missing, did you run certbot?"
	@echo "Need TLS certificate in secrets/jupyterhub.crt"
	@exit 1

secrets/jupyterhub.key:
	@echo "TLS certificates are missing, did you run certbot?"
	@echo "Need TLS private key in secrets/jupyterhub.key"
	@exit 1

# Used if Notebook are exposed to the network (see .env or README.adoc for details)
# Might give a bad IP if external IP is not the first IP on the eth0 adapter
secrets/context.env:
	@echo "Grabbing host context in $@"
	@echo "HOST_IP=$(shell ip addr show eth0 | grep -Po 'inet \K[\d.]+' | head -1)" > $@

# Do not require cert/key files if SECRETS_VOLUME defined
secrets_volume = $(shell echo $(SECRETS_VOLUME))
ifeq ($(secrets_volume),)
	cert_files=secrets/jupyterhub.crt secrets/jupyterhub.key
else
	cert_files=
endif

check-files: $(cert_files) secrets/oauth.env secrets/postgres.env secrets/context.env

pull:
	docker pull $(DOCKER_NOTEBOOK_IMAGE)

#notebook_image: pull singleuser/Dockerfile
notebook_image: singleuser/Dockerfile
	docker build -t $(LOCAL_NOTEBOOK_IMAGE) \
		--build-arg JUPYTERHUB_VERSION=$(JUPYTERHUB_VERSION) \
		--build-arg DOCKER_NOTEBOOK_IMAGE=$(DOCKER_NOTEBOOK_IMAGE) \
		singleuser

build: check-files network volumes
	docker-compose build

.PHONY: network volumes check-files pull notebook_image build

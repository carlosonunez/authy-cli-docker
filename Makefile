#!/usr/bin/env make
MAKEFLAGS += --silent
SHELL := /usr/bin/env bash
EXAMPLE_ENVIRONMENT_FILE ?= $(PWD)/.env.example
ENVIRONMENT_FILE ?= $(PWD)/.env

ifeq ("$(wildcard $(ENVIRONMENT_FILE))","")
ifneq ("$(MAKECMDGOALS)","env")
$(error "Please create a .env with 'make env'.")
endif
endif

ifneq ("$(MAKECMDGOALS)","env")
include $(ENVIRONMENT_FILE)
export $(shell cat $(ENVIRONMENT_FILE)| grep "^\#" | cut -f1 -d '=')
endif

REBUILD_DOCKER_IMAGE ?= false
IMAGE_PATH := $(DOCKER_HUB_USERNAME)/$(IMAGE_NAME)
LATEST_COMMIT_SHA := $(shell git rev-parse HEAD | head -c 8)


.PHONY: env build test deploy

env:
	cat .env.example | grep -v '^#' | sed 's/="change me"/=/' > $(ENVIRONMENT_FILE) && \
		>&2 echo "Your environment file has been created at: $(ENVIRONMENT_FILE)."

build:
	if [ -z "$(IMAGE_NAME)" ] || [ -z "$(DOCKER_HUB_USERNAME)" ]; \
	then \
		>&2 echo "ERROR: Please supply an image name and Docker Hub username."; \
		exit 1; \
	fi; \
	if [ "$(REBUILD_DOCKER_IMAGE)" == "true" ] || \
		! docker images | grep -q "$(IMAGE_PATH)"; \
	then \
		docker build -t "$(IMAGE_PATH):$(LATEST_COMMIT_SHA)" .; \
	fi

test:
	docker run -e DOCKER_IMAGE_UNDER_TEST=$(IMAGE_PATH):$(LATEST_COMMIT_SHA) \
		-v $(PWD):/app \
		-v /var/run/docker.sock:/var/run/docker.sock \
		graze/bats /app/tests

deploy:
	if [ -z "$(DOCKER_HUB_USERNAME)" ] || [ -z "$(DOCKER_HUB_PASSWORD)" ]; \
	then \
		>&2 echo "ERROR: Please provide a Docker username and password."; \
		exit 1; \
	fi; \
	docker login -u $(DOCKER_HUB_USERNAME) -p $(DOCKER_HUB_PASSWORD) && \
	docker tag $(IMAGE_PATH):$(LATEST_COMMIT_SHA) && \
	docker push $(IMAGE_PATH):$(LATEST_COMMIT_SHA);

encrypt_env:
	if [ -z "$(TRAVIS_GITHUB_TOKEN)" ]; \
	then \
		>&2 echo "ERROR: You'll need a GitHub token if you'd like to contribute. \
Follow these instructions to create one: "; \
		exit 1; \
	fi; \
	rm -f .env.enc && \
	docker run -v "$(PWD):/work" \
		-w /work \
		--entrypoint sh \
		skandyla/travis-cli \
			-c "travis login --github-token $(TRAVIS_GITHUB_TOKEN) && travis encrypt-file -a before_install .env"

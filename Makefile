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
	docker run --rm -e DOCKER_IMAGE_UNDER_TEST=$(IMAGE_PATH):$(LATEST_COMMIT_SHA) \
		-v $(PWD):/app \
		-v /var/run/docker.sock:/var/run/docker.sock \
		graze/bats /app/tests

deploy:
	repo_owner=$$(echo $$TRAVIS_REPO_SLUG | cut -f1 -d '/'); \
	git config --global user.email "builds@travis-ci.com" && \
		git config --global user.name "Travis CI" && \
		git config --global credential.helper store && \
		echo "https://$(TRAVIS_GITHUB_TOKEN):x-oauth-basic@github.com" > $$HOME/.git-credentials && \
		git tag $$(date +%Y%m%d) -a -m "Auto-generated by Travis CI, build $$TRAVIS_BUILD_NUMBER" && \
		git push origin $$(date +%Y%m%d) --tags

encrypt_env:
	if [ -z "$(TRAVIS_GITHUB_TOKEN)" ]; \
	then \
		>&2 echo "ERROR: You'll need a GitHub token if you'd like to contribute. \
Follow these instructions to create one: \
https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/"; \
		exit 1; \
	fi; \
	rm -f .env.enc && \
	docker run --rm -v "$(PWD):/work" \
		-w /work \
		--entrypoint sh \
		skandyla/travis-cli \
			-c "travis login --github-token $(TRAVIS_GITHUB_TOKEN) && travis encrypt-file -a before_install .env"

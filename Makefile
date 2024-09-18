all: print

SHARED_DIR=$(abspath ./)
DOCKER_IMAGE_TAG=akilesalreadytaken/latex-env:latest
SHARED_DIR=$(realpath ./shared)

ifneq (,$(ROOT))
_DOCKER_ROOT_USER=--user root
endif

ifneq (,$(NO_CACHE))
_DOCKER_NO_CACHE=--no-cache
endif

USER_ID=$(shell id -u)
USER_GROUP=$(shell id -g)
DOCKER_RUN=docker run -it --rm $(_DOCKER_ROOT_USER) \
	--mount type=bind,source=$(SHARED_DIR),target=/home/dev/shared \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	-v /home/$(USER)/.Xauthority:/root/.Xauthority:rw \
	-v /home/$(USER)/.Xauthority:/home/dev/.Xauthority:rw \
	--net=host \
	-e SHELL=/bin/bash \
	-e DISPLAY \
	-e LIBGL_ALWAYS_INDIRECT=1 \
	-e XDG_RUNTIME_DIR \
	-e PULSE_SERVER \
	-e USER_ID=$(USER_ID) \
	-e USER_GROUP=$(USER_GROUP)


print:
	@echo DOCKER_IMAGE_TAG ........ $(DOCKER_IMAGE_TAG)
	@echo SHARED_DIR .............. $(SHARED_DIR)
	@echo OS ...................... $(OS)
	@echo STAGE ................... $(STAGE)
	@echo CACHE ................... $(_DOCKER_NO_CACHE)
	@echo _DOCKER_ROOT_USER ....... $(_DOCKER_ROOT_USER)
	@echo DOCKER_RUN .............. $(DOCKER_RUN)


build:
ifeq (,$(STAGE))
	BUILDKIT_PROGRESS=plain docker build $(_DOCKER_NO_CACHE) -t $(DOCKER_IMAGE_TAG) .
else
	BUILDKIT_PROGRESS=plain docker build $(_DOCKER_NO_CACHE) -t $(DOCKER_IMAGE_TAG) --target $(STAGE) .
endif
	docker image ls $(DOCKER_IMAGE_TAG)


start: pull
	$(DOCKER_RUN) $(DOCKER_IMAGE_TAG) bash


start-raw:
	docker run -it --rm $(_DOCKER_ROOT_USER) $(DOCKER_IMAGE_TAG)


start-devcontainer: pull
	code $(SHARED_DIR)


push:
	docker image push $(DOCKER_IMAGE_TAG)


pull:
ifeq (,$(NO_PULL))
	docker image pull $(DOCKER_IMAGE_TAG)
endif

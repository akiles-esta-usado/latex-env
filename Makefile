all: print

DOCKER_IMAGE_TAG=akilesalreadytaken/latex-env:latest
SHARED_DIR=$(realpath ./shared)

ifneq (,$(DOCKER_ROOT))
_DOCKER_ROOT_USER=--user root
endif


USER_ID=$(shell id -u)
USER_GROUP=$(shell id -g)
DOCKER_RUN=docker run -it --rm $(_DOCKER_ROOT_USER) \
	--mount type=bind,source=$(SHARED_DIR),target=/home/dev/shared \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	-v /home/$(USER)/.Xauthority:/root/.Xauthority:rw \
	-v /home/$(USER)/.Xauthority:/home/dev/.Xauthority:rw \
	--net=host \
	-e DISPLAY \
	-e XDG_RUNTIME_DIR \
	-e PULSE_SERVER \
	-e USER_ID=$(USER_ID) \
	-e USER_GROUP=$(USER_GROUP)


print:
	@echo _DOCKER_ROOT_USER ....... $(_DOCKER_ROOT_USER)
	@echo DOCKER_RUN .............. $(DOCKER_RUN)
	@echo DOCKER_IMAGE_TAG ........ $(DOCKER_IMAGE_TAG)
	@echo OS ...................... $(OS)


build:
ifeq (,$(DOCKER_STAGE))
	docker build . -t $(DOCKER_IMAGE_TAG)
else
	docker build --target $(DOCKER_STAGE) . -t $(DOCKER_IMAGE_TAG)
endif
	docker image ls $(DOCKER_IMAGE_TAG)


start:
	$(DOCKER_RUN) $(DOCKER_IMAGE_TAG) bash


start-raw: build
	docker run -it --rm $(_DOCKER_ROOT_USER) $(DOCKER_IMAGE_TAG) bash


start-latest: build start


start-devcontainer:
	code $(SHARED_DIR)


push:
	docker image push $(DOCKER_IMAGE_TAG)
ARG BASE_IMAGE=ubuntu:22.04

#######################################################################
# Basic configuration for base and builder
#######################################################################

FROM ${BASE_IMAGE} as common
ARG CONTAINER_TAG=unknown
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Vienna \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    TOOLS=/opt

USER root


#######################################################################
# Setup base image
#######################################################################
# FROM common as base

# RUN --mount=type=bind,source=scripts/base,target=/scripts/base \
#     bash /scripts/base/install.sh \
#     && bash /scripts/base/python_packages.sh \
#     && bash /scripts/base/install_fwup.sh


#######################################################################
# Builder image (Has all iic dependencies)
#######################################################################
# FROM common as builder

# RUN echo "Hello from builder"


#######################################################################
# Final output container
#######################################################################
FROM ${BASE_IMAGE} as common
ARG CONTAINER_TAG=unknown
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Vienna \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    TOOLS=/opt

USER root

RUN --mount=type=bind,source=scripts/base,target=/scripts/base \
    bash /scripts/base/install.sh

RUN useradd -m dev \
    && echo "dev ALL=(ALL:ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/dev
USER dev

COPY --chmod=755 scripts/latex-env/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /home/dev
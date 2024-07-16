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

RUN --mount=type=bind,source=scripts/base,target=/scripts/base \
    bash /scripts/base/install.sh


#######################################################################
# Final output container
#######################################################################
FROM common as latex-env
ARG CONTAINER_TAG=unknown
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Vienna \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    TOOLS=/opt \
    SHELL=/bin/bash

RUN --mount=type=bind,source=scripts/latex-env/install,target=/scripts/latex-env/install \
    bash /scripts/latex-env/install/install.sh

RUN --mount=type=bind,source=scripts/latex-env/config,target=/scripts/latex-env/config \
    bash /scripts/latex-env/config/latex-patches.sh

RUN useradd -m dev \
    && echo "dev ALL=(ALL:ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/dev
USER dev

COPY --chmod=755 scripts/latex-env/config/.bashrc /home/dev/.bashrc
COPY --chmod=755 scripts/latex-env/config/.bashrc /root/.bashrc
COPY --chmod=755 scripts/latex-env/config/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /home/dev
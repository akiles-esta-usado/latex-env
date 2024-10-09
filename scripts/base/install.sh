#!/bin/bash

set -ex

echo "[INFO] Updating, upgrading and installing packages with APT"


apt -y update
apt install -y  --no-install-recommends locales

sed -i -e "s/# $LC_ALL UTF-8/$LC_ALL UTF-8/" /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG=$LANG

apt install -y  --no-install-recommends \
	curl \
	gawk \
	gettext \
	git \
	gnupg2 \
	gpg \
	make \
	openssl \
	texinfo \
	time \
	tzdata \
	zip \
	unzip \
	wget \
	python3-pip \
	sudo \
	tree \
	less \
	parallel \
	htop \
	dbus-x11 \
	ghostscript \
	imagemagick \
	imagemagick-6-common \
	biber \
	latexmk \
	chktex \
	lacheck \
	inkscape \
	openjdk-8-jre-headless

# curl -L http://cpanmin.us | perl - --self-upgrade
# cpanm Log::Dispatch::File YAML::Tiny File::HomeDir

echo "[INFO] Cleaning up caches"
rm -rf /tmp/*
apt -y autoremove --purge
apt -y clean
rm -rf /var/lib/apt/lists/*

update-alternatives --install /usr/bin/python python /usr/bin/python3 0

pip install uv

uv pip install --system --strict --compile-bytecode --no-cache \
	Pygments \
    "numpy<2.0" \
    pandas

#!/bin/bash

set -ex

cd /tmp
curl -L -o install-tl-unx.tar.gz https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
zcat < install-tl-unx.tar.gz | tar xf -
rm install-tl-unx.tar.gz

cd install-tl-*
perl ./install-tl --no-interaction --scheme=full --no-doc-install --no-src-install

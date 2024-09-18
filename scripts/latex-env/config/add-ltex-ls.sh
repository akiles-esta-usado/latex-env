#!/bin/bash

set -ex

curl -L -o ltex-ls.tar.gz https://github.com/valentjn/ltex-ls/releases/download/16.0.0/ltex-ls-16.0.0-linux-x64.tar.gz
zcat < ltex-ls.tar.gz | tar xf -
rm ltex-ls.tar.gz

mkdir -p /opt
mv ltex-ls* /opt
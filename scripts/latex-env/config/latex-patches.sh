#!/bin/bash

set -ex

curl -L http://cpanmin.us | perl - --self-upgrade
cpanm Log::Dispatch::File YAML::Tiny File::HomeDir
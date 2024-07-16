#!/bin/bash

curl -L http://cpanmin.us | perl - --self-upgrade
cpanm Log::Dispatch::File YAML::Tiny File::HomeDir
#tlmgr install latexindent latexmk
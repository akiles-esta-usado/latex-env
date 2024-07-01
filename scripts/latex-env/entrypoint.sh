#!/bin/bash

set -e

[[ -v "${USER_ID}" ]]    && usermod -u $USER_ID dev
[[ -v "${USER_GROUP}" ]] && usermod -g $USER_GROUP dev

if [ "$1" != "" ]; then
    $1
else
    /bin/bash
fi

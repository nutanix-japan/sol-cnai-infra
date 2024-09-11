#!/usr/bin/env bash

set -ex
set -o pipefail

## install common debian packages
if grep -q -i ubuntu /etc/os-release; then
  sudo apt-get update -y && \
  sudo apt-get install -y \
    wget \
    apache2-utils
fi

## install common packages for Rocky Linux
if grep -q -i rocky /etc/os-release; then
  sudo dnf update -y --allowerasing --skip-broken && \
  sudo dnf install -y \
    wget \
    httpd-tools
fi
#!/usr/bin/env bash

set -ex
set -o pipefail

## install common debian packages
if grep -q -i ubuntu /etc/os-release; then
  sudo apt-get update -y && \
  sudo apt-get install -y \
    wget \
    tree \
    vim \
    bash-completion \
    python3 \
    shellcheck \
    fzf \
    tmux \
    zstd \
    apache2-utils \
    xdg-utils \
    nfs-common
fi

## install common packages for Rocky Linux
if grep -q -i rocky /etc/os-release; then
  sudo dnf update -y --allowerasing --skip-broken && \
  sudo dnf install -y \
    wget \
    tree \
    vim \
    bash-completion \
    python3 \
    tmux \
    zstd \
    httpd-tools \
    xdg-utils \
    nfs-common
fi

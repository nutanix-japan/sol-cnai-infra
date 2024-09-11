#!/usr/bin/env bash

set -ex
set -o pipefail

## install gum package
GUM=0.13.0

if [[ $(uname -m) == "x86_64" ]]; then
    curl --silent --location "https://github.com/charmbracelet/gum/releases/download/v${GUM}/gum_${GUM}_Linux_x86_64.tar.gz" | sudo tar xz -C /tmp
elif [[ $(uname -m) == "aarch64" ]]; then
    curl --silent --location "https://github.com/charmbracelet/gum/releases/download/v${GUM}/gum_${GUM}_Linux_arm64.tar.gz" | sudo tar xz -C /tmp
else
    echo "Unsupported architecture"
    exit 1
fi

sudo mv /tmp/gum /usr/local/bin
sudo chmod +x /usr/local/bin/gum

gum --help


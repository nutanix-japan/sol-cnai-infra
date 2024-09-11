#!/usr/bin/env bash

set -ex
set -o pipefail

## install age and agekey-gen binaries - https://github.com/FiloSottile/age
AGE=v1.1.1

if [[ $(uname -m) == "x86_64" ]]; then
    curl "https://github.com/FiloSottile/age/releases/download/${AGE}/age-${AGE}-linux-amd64.tar.gz" --silent --location | sudo tar xz -C /tmp
elif [[ $(uname -m) == "aarch64" ]]; then
    curl "https://github.com/FiloSottile/age/releases/download/${AGE}/age-${AGE}-linux-arm64.tar.gz" --silent --location | sudo tar xz -C /tmp
else
    echo "Unsupported architecture"
    exit 1
fi

sudo mv /tmp/age/age /usr/local/bin/
sudo mv /tmp/age/age-keygen /usr/local/bin/

sudo chmod +x /usr/local/bin/age
sudo chmod +x /usr/local/bin/age-keygen

age --version
age-keygen --version

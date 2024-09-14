#

## New Cluster Walkthrough on HPOC

### Install Utils on New Bastion Host

```bash
## git clone && cd into dir
git clone https://github.com/jesse-gonzalez/sol-cnai-infra.git && cd sol-cnai-infra/

## install go-task
sudo sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

## download nkp binaries to bin directory


## bootstrap jumpbox to install linux depends, nkp, utils, etc.
task workstation:bootstrap-jumpbox --yes

## enter devbox shell
devbox shell
```

### Set Environment Variables

```bash
## set environment sourcefile
eval $(task switch-shell-env)
```

### Create Image

```bash
## create ubuntu image if new cluster.  - 15 min
task nkp:create-nutanix-ubuntu-2204-image
### MANUAL update .env with ubuntu image name
```

### Configure Infra PreReqs

```bash
#### Optional: Create Route53 Records and Certs as needed

## create prism central route53 records and certs
task aws:create-route53-record DNS_RECORD_NAME=prism.dm3-ai02.cloudnative.nvdlab.net DNS_RECORD_IP=10.54.111.39
task aws:create-acme-sh-certs DNS_RECORD_NAME=prism.dm3-ai02.cloudnative.nvdlab.net

## create objects route53 records and certs
task aws:create-route53-record DNS_RECORD_NAME=objects.dm3-ai02.cloudnative.nvdlab.net DNS_RECORD_IP=10.54.111.18
task aws:create-route53-record DNS_RECORD_NAME=objects.dm3-ai02.cloudnative.nvdlab.net DNS_RECORD_IP=10.54.111.19
task aws:create-route53-record DNS_RECORD_NAME=objects.dm3-ai02.cloudnative.nvdlab.net DNS_RECORD_IP=10.54.111.20
task aws:create-acme-sh-certs DNS_RECORD_NAME=objects.dm3-ai02.cloudnative.nvdlab.net

## create files route53 records
task aws:create-route53-record DNS_RECORD_NAME=files.dm3-ai02.cloudnative.nvdlab.net DNS_RECORD_IP=10.54.111.61
task aws:create-route53-record DNS_RECORD_NAME=files.dm3-ai02.cloudnative.nvdlab.net DNS_RECORD_IP=10.54.111.62
task aws:create-route53-record DNS_RECORD_NAME=files.dm3-ai02.cloudnative.nvdlab.net DNS_RECORD_IP=10.54.111.63

## create nkp kommander cluster route53 records and certs for traefik use cases
task aws:create-route53-record DNS_RECORD_NAME=*.nkp.${CLUSTER_NAME}.cloudnative.nvdlab.net DNS_RECORD_IP=10.54.111.51
task aws:create-route53-record DNS_RECORD_NAME=nkp.${CLUSTER_NAME}.cloudnative.nvdlab.net DNS_RECORD_IP=10.54.111.51
task aws:create-acme-sh-certs DNS_RECORD_NAME=nkp.${CLUSTER_NAME}.cloudnative.nvdlab.net

## create istio wildcard dns records for nai
task aws:create-route53-record DNS_RECORD_NAME=*.cnai.${CLUSTER_NAME}.cloudnative.nvdlab.net DNS_RECORD_IP=10.54.111.52
task aws:create-route53-record DNS_RECORD_NAME=cnai.${CLUSTER_NAME}.cloudnative.nvdlab.net DNS_RECORD_IP=10.54.111.52
task aws:create-acme-sh-certs DNS_RECORD_NAME=cnai.${CLUSTER_NAME}.cloudnative.nvdlab.net

## create nginx wildcard dns records for other use cases like harbor
task aws:create-route53-record DNS_RECORD_NAME=*.${CLUSTER_NAME}.cloudnative.nvdlab.net DNS_RECORD_IP=10.54.111.53
task aws:create-route53-record DNS_RECORD_NAME=${CLUSTER_NAME}.cloudnative.nvdlab.net DNS_RECORD_IP=10.54.111.53
task aws:create-acme-sh-certs DNS_RECORD_NAME=${CLUSTER_NAME}.cloudnative.nvdlab.net
```

### Deploy NKP Cluster with GPU NodePool

If deployment fails, resolve issue and re-run, it should skip any tasks already executed.

`task nkp:deploy-nkp-full`

### Deploy NKP Cluster without GPU NodePool

If deployment fails, resolve issue and re-run, it should skip any tasks already executed.

`task nkp:deploy-nkp-minimal`

### Deploy NAI

IN-PROGESS: If deployment fails, resolve issue and re-run, it should skip any tasks already executed.

`task nai:deploy-nai`

## Importing Custom Models from Files into NAI

Required values should be set in .env:

`export HUGGINGFACE_TOKEN='<hf_token>'`
`export NFS_SERVER_FQDN='files.odin.cloudnative.nvdlab.net'`

Default MODEL_NAME is `meta-llama/Meta-Llama-3-8B` and NFS_SHARE is `llm-model-store`

To Mount and Download the target MODEL_NAME from HuggingFace, use the following task:

`task huggingface:download-model`

```bash
## Override Model Name
`task huggingface:download-model MODEL_NAME=meta-llama/Meta-Llama-3.1-70B-Instruct`

## Override Model Directory and Model Name
`task huggingface:download-model MODEL_NAME=meta-llama/Meta-Llama-3.1-70B-Instruct`

## Optionally, you can set .env to include any overrides 
export NFS_SHARE='llm-model-store'
export MODEL_NAME='meta-llama/Meta-Llama-3.1-70B-Instruct'

```

Example Directory with Model Downloads:
```
$ ls -lathr /mnt/files.odin.cloudnative.nvdlab.net/llm-model-store/meta-llama/Meta-Llama-3.1-70B-Instruct/*.safetensors
-rw-rw-r-- 1 ubuntu ubuntu 4.4G Sep 14 16:09 /mnt/files.odin.cloudnative.nvdlab.net/llm-model-store/meta-llama/Meta-Llama-3.1-70B-Instruct/model-00005-of-00030.safetensors
-rw-rw-r-- 1 ubuntu ubuntu 4.3G Sep 14 16:09 /mnt/files.odin.cloudnative.nvdlab.net/llm-model-store/meta-llama/Meta-Llama-3.1-70B-Instruct/model-00001-of-00030.safetensors
-rw-rw-r-- 1 ubuntu ubuntu 4.7G Sep 14 16:09 /mnt/files.odin.cloudnative.nvdlab.net/llm-model-store/meta-llama/Meta-Llama-3.1-70B-Instruct/model-00004-of-00030.safetensors
-rw-rw-r-- 1 ubuntu ubuntu 4.4G Sep 14 16:09 /mnt/files.odin.cloudnative.nvdlab.net/llm-model-store/meta-llama/Meta-Llama-3.1-70B-Instruct/model-00006-of-00030.safetensors
-rw-rw-r-- 1 ubuntu ubuntu 4.4G Sep 14 16:10 /mnt/files.odin.cloudnative.nvdlab.net/llm-model-store/meta-llama/Meta-Llama-3.1-70B-Instruct/model-00007-of-00030.safetensors
-rw-rw-r-- 1 ubuntu ubuntu 4.4G Sep 14 16:10 /mnt/files.odin.cloudnative.nvdlab.net/llm-model-store/meta-llama/Meta-Llama-3.1-70B-Instruct/model-00002-of-00030.safetensors
```

## Looping through multiple models

```bash
## example script to loop through multiple models and download
models=(
    "neuralmagic/Mixtral-8x7B-Instruct-v0.1-FP8"
    "neuralmagic/Meta-Llama-3-8B-Instruct-FP8-KV"
    "neuralmagic/Meta-Llama-3-70B-Instruct-FP8-KV"
    "neuralmagic/Mixtral-8x22B-Instruct-v0.1-FP8"
    "neuralmagic/Mixtral-8x22B-Instruct-v0.1-FP8-dynamic"
    "neuralmagic/Mistral-7B-Instruct-v0.3-FP8"
    "neuralmagic/gemma-2-9b-it-FP8"
)

for model in "${models[@]}"; do
   task huggingface:download-model MODEL_NAME=$model
done
```
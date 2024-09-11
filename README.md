1. Update .env-<pc-environment> && run `export ENVIRONMENT=<pc-environment>`.  Ex. export ENVIRONMENT=dragon
2. [Optional] Create AWS Domain Records and Certs - Run for each domain/wildcard domain needed. Files generated in "out" directory  
   1. Traefik Ingress:
      1. task aws:create-route53-record DNS_RECORD_NAME=*.vllm-nkp-nai.cloudnative.nvdlab.net DNS_RECORD_IP=10.124.62.142
      2. task aws:create-acme-sh-certs DNS_RECORD_NAME=vllm-nkp-nai.cloudnative.nvdlab.net
   2. Istio Ingress:
      1. task aws:create-route53-record DNS_RECORD_NAME=*.istio.vllm-nkp-nai.cloudnative.nvdlab.net DNS_RECORD_IP=10.124.62.143
      2. task aws:create-acme-sh-certs DNS_RECORD_NAME=istio.vllm-nkp-nai.cloudnative.nvdlab.net
   3. TODO: Self-Signed
3. Create NKP Cluster End to End with GPU nodepool
   1. [Optional] task nkp:create-nutanix-ubuntu-2204-image && Update .env-<cluster-name> with updated nkp-image-name
   2. task nke:deploy-nkp-gpu
4. Deploy NAI End to End
   1. task nai:deploy-nai
5. Post Install Tasks (Manual)
   1. Navigate to Kommander Dashboard and Enable GPU Operator (driver: enabled: true)

## Dragon KABOOM (E2E) - New Cluster Walkthrough on Dragon

```bash
export ENVIRONMENT=dragon-nai-nkp-len
eval $(task switch-shell-env)

## create DNS Host record - 1 min
task aws:create-route53-record DNS_RECORD_NAME=*.nkp.${CLUSTER_NAME}.dragon.cloudnative.nvdlab.net DNS_RECORD_IP=10.124.62.136
task aws:create-route53-record DNS_RECORD_NAME=*.cnai.${CLUSTER_NAME}.dragon.cloudnative.nvdlab.net DNS_RECORD_IP=10.124.62.137
task aws:create-route53-record DNS_RECORD_NAME=*.nginx.${CLUSTER_NAME}.dragon.cloudnative.nvdlab.net DNS_RECORD_IP=10.124.62.138

## create Certs with wildcard and record_name - 5 min
task aws:create-acme-sh-certs DNS_RECORD_NAME=nkp.${CLUSTER_NAME}.dragon.cloudnative.nvdlab.net
task aws:create-acme-sh-certs DNS_RECORD_NAME=cnai.${CLUSTER_NAME}.dragon.cloudnative.nvdlab.net
task aws:create-acme-sh-certs DNS_RECORD_NAME=nginx.${CLUSTER_NAME}.dragon.cloudnative.nvdlab.net

## Deploy NKP and NAI End-to-End, No Coffee Breaks...Good Luck!
task deploy-nkai-kaos
```

## Romanticism KABOOM (E2E) - New Cluster Walkthrough on Dragon

export ENVIRONMENT=romanticism
task aws:create-route53-record DNS_RECORD_NAME=*.vllm-nkp-nai.romanticism.cloudnative.nvdlab.net DNS_RECORD_IP=10.124.62.136
task aws:create-acme-sh-certs DNS_RECORD_NAME=vllm-nkp-nai.romanticism.cloudnative.nvdlab.net
task aws:create-route53-record DNS_RECORD_NAME=*.istio.vllm-nkp-nai.romanticism.cloudnative.nvdlab.net DNS_RECORD_IP=10.124.62.137
task aws:create-acme-sh-certs DNS_RECORD_NAME=istio.vllm-nkp-nai.romanticism.cloudnative.nvdlab.net

task kaboom

## Odin KABOOM (E2E) - New Cluster Walkthrough on Odin

```bash
## set environment
source .env-odin-nai-nkp-mgx

## create ubuntu image if new cluster - 15 min
task nkp:create-nutanix-ubuntu-2204-image

## create DNS Host record for Objects and Files
task aws:create-route53-record DNS_RECORD_NAME=objects.odin.cloudnative.nvdlab.net DNS_RECORD_IP=10.28.174.147
task aws:create-route53-record DNS_RECORD_NAME=objects.odin.cloudnative.nvdlab.net DNS_RECORD_IP=10.28.174.148
task aws:create-route53-record DNS_RECORD_NAME=objects.odin.cloudnative.nvdlab.net DNS_RECORD_IP=10.28.174.149
task aws:create-acme-sh-certs DNS_RECORD_NAME=objects.odin.cloudnative.nvdlab.net

task aws:create-route53-record DNS_RECORD_NAME=files.odin.cloudnative.nvdlab.net DNS_RECORD_IP=10.28.174.151
task aws:create-route53-record DNS_RECORD_NAME=files.odin.cloudnative.nvdlab.net DNS_RECORD_IP=10.28.174.152
task aws:create-route53-record DNS_RECORD_NAME=files.odin.cloudnative.nvdlab.net DNS_RECORD_IP=10.28.174.153


## set environment
source .env-odin-nai-nkp-mgx

## create DNS Host record - 1 min
task aws:create-route53-record DNS_RECORD_NAME=*.nkp.${CLUSTER_NAME}.odin.cloudnative.nvdlab.net DNS_RECORD_IP=10.28.174.211
task aws:create-route53-record DNS_RECORD_NAME=*.cnai.${CLUSTER_NAME}.odin.cloudnative.nvdlab.net DNS_RECORD_IP=10.28.174.212
task aws:create-route53-record DNS_RECORD_NAME=*.nginx.${CLUSTER_NAME}.odin.cloudnative.nvdlab.net DNS_RECORD_IP=10.28.174.213

## create Certs with wildcard and record_name - 5 min
task aws:create-acme-sh-certs DNS_RECORD_NAME=nkp.${CLUSTER_NAME}.odin.cloudnative.nvdlab.net
task aws:create-acme-sh-certs DNS_RECORD_NAME=cnai.${CLUSTER_NAME}.odin.cloudnative.nvdlab.net
task aws:create-acme-sh-certs DNS_RECORD_NAME=nginx.${CLUSTER_NAME}.odin.cloudnative.nvdlab.net

## Deploy NKP and NAI End-to-End, No Coffee Breaks...Good Luck!
task deploy-nkai-kaos

```


## Datarobot New Cluster Walkthrough on HPOC

```bash

export ENVIRONMENT=datarobot-nkp-lab

## set environment sourcefile
eval $(task switch-shell-env)

## create ubuntu image if new cluster - 15 min
task nkp:create-nutanix-ubuntu-2204-image

## create DNS Host record - 1 min
task aws:create-route53-record DNS_RECORD_NAME=*.nkp.${CLUSTER_NAME}.cloudnative.nvdlab.net DNS_RECORD_IP=10.38.20.141
task aws:create-route53-record DNS_RECORD_NAME=*.cnai.${CLUSTER_NAME}.cloudnative.nvdlab.net DNS_RECORD_IP=10.38.20.142
task aws:create-route53-record DNS_RECORD_NAME=*.dr.${CLUSTER_NAME}.cloudnative.nvdlab.net DNS_RECORD_IP=10.38.20.143

## create Certs with wildcard and record_name - 5 min
task aws:create-acme-sh-certs DNS_RECORD_NAME=nkp.${CLUSTER_NAME}.cloudnative.nvdlab.net
task aws:create-acme-sh-certs DNS_RECORD_NAME=cnai.${CLUSTER_NAME}.cloudnative.nvdlab.net
task aws:create-acme-sh-certs DNS_RECORD_NAME=dr.${CLUSTER_NAME}.cloudnative.nvdlab.net

## Deploy NKP and NAI End-to-End, No Coffee Breaks...Good Luck!
task deploy-nkai-kaos

```

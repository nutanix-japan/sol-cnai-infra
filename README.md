#

## New Cluster Walkthrough on HPOC

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

`task nkp:deploy-nkp-full`

### Deploy NKP Cluster without GPU NodePool

`task nkp:deploy-nkp-minimal`

### Deploy NAI

`task nai:deploy-nai`
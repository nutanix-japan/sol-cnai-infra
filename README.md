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

## New Cluster Walkthrough on HPOC

```bash
## set environment sourcefile
eval $(task switch-shell-env)

## create ubuntu image if new cluster.  - 15 min
task nkp:create-nutanix-ubuntu-2204-image

### MANUAL update .env with ubuntu image name

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
 
## Deploy NKP and NAI End-to-End, No Coffee Breaks...Good Luck!
task deploy-nkai-kaos

## IRS NAI ENVIRONMENT DETAILS

NKP Dashboard URL: https://10.54.111.51/dkp/kommander/dashboard
Username: laughing_kalam
Password: Bo9K792f6ZcMfhYBKxUJGSpzukjTa1QoxgFefo5ccYeL1XHolWINap9ElmvZke4Z

NAI Dashboard URL: https://nai.cnai.irs-nai-nkp.cloudnative.nvdlab.net
Chat Application UR: https://chat.cnai.irs-nai-nkp.cloudnative.nvdlab.net/

admin-api-key: c1f59ff4-65af-4176-aff6-2e21700584dd



```

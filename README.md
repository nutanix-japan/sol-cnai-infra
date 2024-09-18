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

## Performance Testing with NAI Endpoints using NVIDIA GenAI-Perf

https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/client/src/c%2B%2B/perf_analyzer/genai-perf/README.html

```bash
export RELEASE="24.06" # recommend using latest releases in yy.mm format

## easier to run from docker then install via pip
docker run --cpus 8 -it --net=host -v `pwd`:/workdir -w '/workdir' nvcr.io/nvidia/tritonserver:${RELEASE}-py3-sdk

docker run --rm -it --net=host -v `pwd`:/workdir -w '/workdir' nvcr.io/nvidia/tritonserver:${RELEASE}-py3-sdk

## set HF_TOKEN and Login
export HF_HUB_TOKEN=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
huggingface-cli login --token ${HF_HUB_TOKEN}

## set NAI_OPENAI_API_KEY and NAI endpoint URL
export NAI_OPENAI_API_KEY=1e4267ba-b12a-4b9d-90d6-d1cf1a26aeb2
export URL=https://nai.cnai.nai-nkp-mgx.odin.cloudnative.nvdlab.net/api

####### ONLY SET ONE OF THESE USE CASES
## Defaults
export SYSTEM_PROMPT_SEQUENCE_LENGTH=10

## test use case 1 - chat q&a (small input/output - 30k requests)
export INPUT_SEQUENCE_LENGTH=128
export INPUT_SEQUENCE_STD=0
export OUTPUT_SEQUENCE_LENGTH=128
export OUTPUT_SEQUENCE_STD=0
export NUMBER_OF_PROMPTS=30000
export CONCURRENCY=100

## test use case 2 - chat q&a (small input/medium output - 3k requests)
export INPUT_SEQUENCE_LENGTH=128
export INPUT_SEQUENCE_STD=0
export OUTPUT_SEQUENCE_LENGTH=2048
export OUTPUT_SEQUENCE_STD=0
export NUMBER_OF_PROMPTS=3000
export CONCURRENCY=10

## test use case 3 - chat q&a (small input/large output - 1.5k requests)
export INPUT_SEQUENCE_LENGTH=128
export INPUT_SEQUENCE_STD=0
export OUTPUT_SEQUENCE_LENGTH=4096
export OUTPUT_SEQUENCE_STD=0
export NUMBER_OF_PROMPTS=150
export CONCURRENCY=10

## test use case 4 - text summarization (classification - 3k requests)
export INPUT_SEQUENCE_LENGTH=2048
export INPUT_SEQUENCE_STD=0
export OUTPUT_SEQUENCE_LENGTH=128
export OUTPUT_SEQUENCE_STD=0
export NUMBER_OF_PROMPTS=3000
export CONCURRENCY=10

## test use case 5 - chat co-pilot (large input/large output - 1.5k requests)
export INPUT_SEQUENCE_LENGTH=2048
export INPUT_SEQUENCE_STD=0
export OUTPUT_SEQUENCE_LENGTH=2048
export OUTPUT_SEQUENCE_STD=0
export NUMBER_OF_PROMPTS=1500
export CONCURRENCY=10

####### ONLY SET ONE OF THESE MAX_TOKENS VALUES based on NAI ENDPOINT & Model Deployed
## modify MAX_TOKENS based on GPU_COUNT and MODEL. Effectively trying to validate throughput based on dynamic batching provided by vLLM

### 1x GPU (L40S) x1 Replica (VM)
### Examples: meta-llama/Meta-Llama-3-8B-Instruct
## MODEL value should match name in NAI endpoint
export MODEL=llama-3-8b-instruct
export GPU_MODEL=L40S
export GPU_COUNT=1
export REPLICA_COUNT=1
export MAX_TOKENS=8192

### 2x GPU (L40S) x1 Replica (VM)
### Examples: meta-llama/CodeLlama-34b-Instruct-hf
## MODEL value should match name in NAI endpoint
export MODEL=codellama-34b-inst
export GPU_MODEL=L40S
export GPU_COUNT=2
export REPLICA_COUNT=1
export MAX_TOKENS=2048

### 4x GPU (L40S) x1 Replica (VM)
### Examples: meta-llama/Meta-Llama-3-70B-Instruct,meta-llama/CodeLlama-70b-Instruct-hf,mistralai/Mixtral-8x7B-Instruct-v0.1
## MODEL value should match name in NAI endpoint
export MODEL=llama-3-70b-instruct
export GPU_MODEL=L40S
export GPU_COUNT=4
export REPLICA_COUNT=1
export MAX_TOKENS=8192

### 8x GPU (L40S) x2 Replica (VM) (SPANNING 2 PHYSICAL NODES)
### Stretch use case for validating Load Balancing across 2 instances - NOT Pipeline Parallelization.
### Examples meta-llama/Meta-Llama-3-70B-Instruct,meta-llama/CodeLlama-70b-Instruct-hf,mistralai/Mixtral-8x7B-Instruct-v0.1
export MODEL=llama-3-70b-instruct
export GPU_MODEL=L40S
export GPU_COUNT=8
export REPLICA_COUNT=2
export MAX_TOKENS=16384

###############
## Calculate actual max tokens available after system and input prompt tokens are accounted for...

export MAX_TOKENS=$((MAX_TOKENS - SYSTEM_PROMPT_SEQUENCE_LENGTH - INPUT_SEQUENCE_LENGTH))

###############
## Setup Profile Name used for Generated Benchmark Results
export PROFILE_NAME="${MODEL}_${GPU_MODEL}x${GPU_COUNT}x${REPLICA_COUNT}_${MAX_TOKENS}_${INPUT_SEQUENCE_LENGTH}_${OUTPUT_SEQUENCE_LENGTH}_${NUMBER_OF_PROMPTS}_profile_export.json"

### Example: This will ensure you can keep track of results based on Model and Test Config. i.e., llama-3-70b-instruct_L40Sx4x1_8054_128_128_1_profile_export.json

echo $PROFILE_NAME

## validate connectivity before test
curl -v -k -X 'POST' ${URL}/v1/chat/completions \
 -H "Authorization: Bearer ${NAI_OPENAI_API_KEY}" \
 -H 'accept: application/json' \
 -H 'Content-Type: application/json' \
 -d "{
      \"model\": \"$MODEL\",
      \"messages\": [
        {
            \"role\": \"system\",
            \"content\": \"You are a helpful assistant.\"
        },
        {
          \"role\": \"user\",
          \"content\": \"Explain Deep Neural Networks in simple terms\"
        }
      ],
      \"max_tokens\": $MAX_TOKENS,
      \"stream\": false
}"

## Run test
genai-perf \
    -m $MODEL \
    --service-kind openai \
    --endpoint v1/chat/completions \
    --endpoint-type chat \
    --streaming \
    --backend vllm \
    --profile-export-file $PROFILE_NAME \
    --url $URL \
    --synthetic-input-tokens-mean $INPUT_SEQUENCE_LENGTH \
    --synthetic-input-tokens-stddev $INPUT_SEQUENCE_STD \
    --concurrency $CONCURRENCY \
    --num-prompts $NUMBER_OF_PROMPTS \
    --random-seed 123 \
    --output-tokens-mean $OUTPUT_SEQUENCE_LENGTH \
    --output-tokens-stddev $OUTPUT_SEQUENCE_STD \
    --artifact-dir genai-perf-results \
    --tokenizer "hf-internal-testing/llama-tokenizer" \
    --extra-inputs max_tokens:$MAX_TOKENS \
    --generate-plots \
    --measurement-interval 100000 \
    -v \
    -- \
    -H "Authorization: Bearer $NAI_OPENAI_API_KEY"  
```
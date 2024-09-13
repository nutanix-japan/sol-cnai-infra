#!/usr/bin/env bash

set -ex
set -o pipefail

#kubectl apply -f scripts/nai/filestemp-secret.yaml

cat <<EOF | kubectl apply -f -
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
    name: nai-nfs-storage
provisioner: csi.nutanix.com
parameters:
  dynamicProv: ENABLED
  nfsServerName: files
  csi.storage.k8s.io/provisioner-secret-name: nutanix-csi-credentials-files
  csi.storage.k8s.io/provisioner-secret-namespace: ntnx-system
  csi.storage.k8s.io/node-publish-secret-name: nutanix-csi-credentials-files
  csi.storage.k8s.io/node-publish-secret-namespace: ntnx-system
  csi.storage.k8s.io/controller-expand-secret-name: nutanix-csi-credentials-files
  csi.storage.k8s.io/controller-expand-secret-namespace: ntnx-system
  storageType: NutanixFiles
allowVolumeExpansion: true
EOF

#kubectl create secret tls -n istio-system iep-cert --cert=fullchain.crt --key=wh-nkp2.cloudnative.nvdlab.net.key

kubectl patch gateway -n knative-serving knative-ingress-gateway --type merge --patch-file=/dev/stdin <<EOF
spec:
  servers:
  - hosts:
    - '*'
    port:
      name: https
      number: 443
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: iep-cert
EOF

kubectl apply -f scripts/nai/chat.yaml

# Construct the service URL
service_url="https://nai.${ISTIO_DNS_NAME}"

echo "=============================================="
echo "\nCongrats! NAI Inference endpoint is installed"
echo "Dashboard url: $service_url"

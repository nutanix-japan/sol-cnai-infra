#cloud-config
hostname: ${hostname}
sudo: ALL=(ALL)
ssh_pwauth: true
chpasswd:
  expire: false
  users:
  - name: ${username}
    password: ${password}
    type: text
    groups: sudo
    shell: /bin/bash
bootcmd:
- mkdir -p /etc/docker
write_files:
- content: |
    {
        "insecure-registries": [
          "registry.nutanixdemo.com",
          "harbor.infrastructure.cloudnative.nvdlab.net"
        ]
    }
  path: /etc/docker/daemon.json
ssh-authorized-keys: 
%{ for ssh_public_key in ssh_public_keys ~}
- ${ssh_public_key}
%{ endfor ~}
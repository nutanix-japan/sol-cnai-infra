terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = "1.9.5"
    }
  }
}

locals {
  infra = yamldecode(file("${path.module}/.env.${terraform.workspace}.yaml")).infra
}

locals {
  cloud_init_content = templatefile("${path.module}/cloud-init.tpl", {
    hostname = local.infra.jumphost.name
    username = local.infra.jumphost.username
    password = local.infra.jumphost.password
    ssh_public_keys = [for path in local.infra.jumphost.ssh_public_keys : file(path)]
  })
}

data "nutanix_cluster" "cluster" {
  name = local.infra.nutanix.prism_element.cluster_name
}

data "nutanix_subnet" "subnet" {
  subnet_name = local.infra.nutanix.prism_element.subnet_name
}

provider "nutanix" {
  username     = local.infra.nutanix.prism_central.username
  password     = local.infra.nutanix.prism_central.password
  endpoint     = local.infra.nutanix.prism_central.endpoint
  insecure     = local.infra.nutanix.prism_central.insecure
  wait_timeout = 60
}

resource "nutanix_image" "machine-image" {
  name        = element(split("/", local.infra.jumphost.source_uri), length(split("/", local.infra.jumphost.source_uri)) - 1)
  description = "opentofu managed image"
  source_uri  = local.infra.jumphost.source_uri
}

resource "nutanix_virtual_machine" "nai-llm-jumphost" {
  name                 = local.infra.jumphost.name
  cluster_uuid         = data.nutanix_cluster.cluster.id
  num_vcpus_per_socket = local.infra.jumphost.num_vcpus_per_socket
  num_sockets          = local.infra.jumphost.num_sockets
  memory_size_mib      = local.infra.jumphost.memory_gb * 1024
  guest_customization_cloud_init_user_data = base64encode(local.cloud_init_content)
  disk_list {
    data_source_reference = {
      kind = "image"
      uuid = nutanix_image.machine-image.id
    }
    disk_size_mib = local.infra.jumphost.disk_gb * 1024
  }
  nic_list {
    subnet_uuid = data.nutanix_subnet.subnet.id
  }

  depends_on = [nutanix_image.machine-image]
}

output "nai-llm-jumphost-ip-address" {
  value = nutanix_virtual_machine.nai-llm-jumphost.nic_list_status[0].ip_endpoint_list[0].ip
  description = "IP address of the Jump Host vm"
}
locals {
  virtual_machine_name = "${var.prefix}-vm"
  admin_username       = "adminuser"
  admin_ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKHRzr355JcF/bD38CQ44O3xd+psx1nyxOoq7ba1Q5PI2N3tV4xV8i7f7fCsFyIa6/5yKsQJnL10AbT6KyEZmf+dwBqcuz86NA/AgOrUrUzPQz8CZVTnbGXr8TChZRHt6UpqCHdBc22rm5dDS9HHJ/ONUOnQ8puWHJxCLqyr6M1SjLZ2WY0T5p4fre4Kei419vI3hoK29ULSdo7LVU7diaipWzCL6Lgk3XtbZph6EAD8Kr9g5xXTuoDt4p0wZ+FSTtZ2piAFZGxWOgpkhWCp2F16JUKD3xAFQGA7HR72K0+OXnh0V8s3X5V2yVu/53bYs7pLsk4fGkRZn9aaKNm5p7 johndore@johndore"
}


resource "azurerm_resource_group" "resource_group" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"

}

resource "azurerm_kubernetes_cluster" "test" {
  name                   = "example-aks-cluster"
  resource_group_name    = "${azurerm_resource_group.resource_group.name}"
  location               = "${var.location}"
  dns_prefix          = "${var.dns_name_prefix}"


  agent_pool_profile {
    name       = "agentpools"
    count      = "${var.linux_agent_count}"
    vm_size    = "${var.linux_agent_vm_size}"
  }

  linux_profile {
    admin_username = "${local.admin_username}"

    ssh_key {
      key_data = "${local.admin_ssh_public_key}"
    }
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

}


output "id" {
  value = "${azurerm_kubernetes_cluster.test.id}"
}

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.test.kube_config_raw}"
}

output "client_key" {
  value = "${azurerm_kubernetes_cluster.test.kube_config.0.client_key}"
}

output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.test.kube_config.0.client_certificate}"
}

output "cluster_ca_certificate" {
  value = "${azurerm_kubernetes_cluster.test.kube_config.0.cluster_ca_certificate}"
}

output "host" {
  value = "${azurerm_kubernetes_cluster.test.kube_config.0.host}"
}

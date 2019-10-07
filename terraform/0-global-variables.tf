#DevopsAccount04
variable "subscription_id" {
  description = "Enter Subscription ID for provisioning resources in Azure"
  default     = "8b56d223-7c2a-425b-a020-e8021bd2e3a2"
}

variable "client_secret" {
  description = "Enter Client secret for Application in Azure AD"
  default     = "fd7dfbea-d17d-4590-b091-4552fa4dd9dd"
}

variable "client_id" {
  description = "Enter Client ID for Application in Azure AD"
  default     = "61d90ca4-ac97-45c5-9cdc-9575164fd4a6"
}

variable "tenant_id" {
  description = "Enter Tenand ID / Directory ID  of your Azure AD. Login Azure id script install cli"
  default     = "6860571d-6fcd-4b97-99cd-c6e90d8ccfe8"
}

variable "location" {
  description = "The default Azure region for the resource provisioning"
  default     = "East US"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Tag to group resources"
}

variable "resource_group_name" {
  description = "The default Azure region for the resource provisioning"
  default     = "aks-rg"
}

variable "prefix" {
  description = "The Prefix used for all resources in this example"
  default     = "practice-aks"
}

variable "linux_agent_count" {
  type        = "string"
  default     = "1"
  description = "The number of Kubernetes linux agents in the cluster. Allowed values are 1-100 (inclusive). The default value is 1."
}

variable "dns_name_prefix" {
  type        = "string"
  default =     "AKSCluster-Example"
  description = "Sets the domain name prefix for the cluster. The suffix 'master' will be added to address the master agents and the suffix 'agent' will be added to address the linux agents."
}

variable "linux_agent_vm_size" {
  type        = "string"
  default     = "Standard_D2_v2"
  description = "The size of the virtual machine used for the Kubernetes linux agents in the cluster."
}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

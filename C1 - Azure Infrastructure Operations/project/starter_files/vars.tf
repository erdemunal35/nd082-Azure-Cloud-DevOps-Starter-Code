variable "prefix" {
  default = "udacity"
  description = "The prefix which should be used for all resources in this main"
}

variable "subscription_id" {
  description = "Azure Subscription ID"
}

variable "resource_group_name" {
  description = "Precreated Azure resource group name. Creating or deleting resource groups is not allowed with Udacity Lab odl account"
}

variable "image_name" {
  description = "Name of the image created by Packer"
}

variable "location" {
  description = "The Azure Region in which all resources in this main should be created."
}

variable "project_tag" {
  description = "The Azure Project tag which will be shared among resources"
}

variable "admin_username" {
  default = "admin"
  description = "The username of the administrator."
}

variable "admin_password" {
  default = "admin"
  description = "Password of the administrator."
}

variable "vm_count" {
  default = 2
  description = "Number of VM to be created and attach to load balancer."
}

variable "fault_domain_count"{
    default = 2
    description = "The number of fault domains that are used in availabilty set."
}
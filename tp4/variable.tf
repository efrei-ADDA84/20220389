variable "region" {
  type = string
  default = "france central"
}

variable "azure_resource_group" {
  type = string
  default = "ADDA84-CTP"
}

variable "network" {
  type = string
  default = "network-tp4"
}

variable "subnet" {
  type = string
  default = "internal"
}

variable "vm_size" {
  type = string
  default = "Standard_D2s_v3"
}

variable "user_admin" {
  type = string
  default = "devops"
}

variable "os" {
  type = string
  default = "Ubuntu 16.04-LTS"
}
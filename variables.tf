# Secrets
variable "ACCOUNT_JSON" {}
variable "INSTANCE_SSH_KEY" {}
variable "ROBBINS_PAGE_PEM" {}
variable "ROBBINS_PAGE_KEY" {}

variable "project" {
  default = "personal-robbins-website-prod"
}

variable "zone" {
  default = "us-east1-b"
}

variable "region" {
  default = "us-east1"
}

variable "machine_type" {
  default = "e2-micro"
}

variable "network_name" {
  default = "default"
}

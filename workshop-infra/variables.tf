variable "workshop_name" {
  description = "What's the name of the workshop"
  type        = string
}

variable "instance_region" {
  description = "DigitalOcean resource region"
  type        = string
  default     = "tor1"
}

variable "instance_size" {
  description = "DigitalOcean instance size"
  type        = string
  # You can find droplet sizes here: https://slugs.do-api.dev/
  default     = "s-1vcpu-2gb"
}

variable "tag_owner" {}
variable "tag_event" {}
variable "tag_purpose" {}
variable "do_token" {}

# Not managed by Terraform
data "digitalocean_project" "workshops" {
  name = "R&D Workshops"
}

# Tags
locals {
  tags = [
    var.workshop_name,
    var.tag_owner,
    var.tag_purpose,
    var.tag_event
  ]
}
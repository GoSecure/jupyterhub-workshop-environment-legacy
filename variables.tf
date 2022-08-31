variable "workshop_name" {}
variable "tag_owner" {}
variable "tag_event" {}
variable "tag_purpose" { default = "jupyterhub" }
variable "do_token" {}
variable "instance_size" {
  # You can find droplet sizes here: https://slugs.do-api.dev/
  default     = "s-1vcpu-2gb"
}
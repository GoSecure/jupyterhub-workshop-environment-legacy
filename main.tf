module "jupyter-hub-workshop" {
  source = "./workshop-infra/"
  workshop_name = var.workshop_name
  instance_size = var.instance_size
  tag_owner = var.tag_owner
  tag_event = var.tag_event
  tag_purpose = var.tag_purpose
  do_token = var.do_token
}

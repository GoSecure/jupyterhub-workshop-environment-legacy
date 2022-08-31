# Keypair
resource "tls_private_key" "do_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4089
}

resource "digitalocean_ssh_key" "do_ssh_key" {
  name       = "${var.workshop_name}-ssh-key"
  public_key = tls_private_key.do_ssh_key.public_key_openssh
}

# Server (Droplet)
resource "digitalocean_droplet" "jupyterhub-server" {
  image    = "ubuntu-22-04-x64"
  name     = var.workshop_name
  region   = var.instance_region
  vpc_uuid = digitalocean_vpc.vpc.id

  size        = var.instance_size
  resize_disk = false
  tags        = local.tags
  ssh_keys    = [digitalocean_ssh_key.do_ssh_key.fingerprint]
}

resource "null_resource" "provision" {

  connection {
    host        = digitalocean_droplet.jupyterhub-server.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = tls_private_key.do_ssh_key.private_key_openssh
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "until [ -f /var/lib/cloud/instance/boot-finished ]; do sleep 1; done",
      "apt -y update",
      "apt install -y rng-tools docker.io docker-compose make certbot",
      "mkdir -p /srv/workshop/"
    ]
  }

  provisioner "file" {
    source      = "jupyterhub"
    destination = "/srv/"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod a+x /srv/jupyterhub/examples/*/*.sh"
    ]
  }

  provisioner "file" {
    source      = "labs-source"
    destination = "/srv/workshop/"
  }
}

# Assigns the resource to the Honeypots project
resource "digitalocean_project_resources" "Workshops_resources" {
  project   = data.digitalocean_project.workshops.id
  resources = [digitalocean_droplet.jupyterhub-server.urn]
}

# Assigns random VPC to avoid default VPC exposure to other infrastructure
resource "random_pet" "vpc_name" {}
resource "digitalocean_vpc" "vpc" {
  name   = "workshop-vpc-${random_pet.vpc_name.id}"
  region = var.instance_region
}
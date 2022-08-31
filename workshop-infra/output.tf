output "instance_public_key" {
  value = tls_private_key.do_ssh_key.public_key_openssh
}

output "instance_private_key" {
  value     = tls_private_key.do_ssh_key.private_key_pem
  sensitive = true
}